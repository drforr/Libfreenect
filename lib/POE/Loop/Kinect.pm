
# Kinect event loop bridge for POE::Kernel.

# Empty package to appease perl.
package POE::Loop::Kinect;

use strict;

# Include common signal handling.
use POE::Loop::PerlSignals;

use vars qw($VERSION);
$VERSION = '1.305'; # NOTE - Should be #.### (three decimal places)

=for poe_tests

sub skip_tests {
  my $test_name = shift;
  return "Gtk needs a DISPLAY (set one today, okay?)" unless (
    defined $ENV{DISPLAY} and length $ENV{DISPLAY}
  );
  return "Gtk tests require the Gtk module" if do { eval "use Gtk"; $@ };
  return "Gtk init failed.  Is DISPLAY valid?" unless defined Gtk->init_check;
  if ($test_name eq "z_rt39872_sigchld_stop") {
    return "Gdk crashes";
  }
  return;
}

=cut

# Everything plugs into POE::Kernel.
package POE::Kernel;

use strict;
use Gtk;

my $_watcher_timer;
my @fileno_watcher;
my $gtk_init_check;

#------------------------------------------------------------------------------
# Loop construction and destruction.

sub loop_initialize {
  my $self = shift;

  # Must Gnome->init() yourselves, as it takes parameters.
  unless (exists $INC{'Gnome.pm'}) {
    # Gtk can only be initialized once.
    # So if we've initialized it already, skip the whole deal.
    unless($gtk_init_check) {
      $gtk_init_check++;

      # Clear errno to avoid bleed-through during potential error display.
      $! = 0;

      # TODO - Force detection on.  For some reason it's returning
      # false when Gtk is present and accounted for.
      my $res = 1 || Gtk->init_check();

      # Now check whether the init was ok.
      # undefined == icky; TRUE (whatever that means in gtk land) means Ok.
      if (defined $res) {
        Gtk->init();
      } else {
        POE::Kernel::_die "Gtk initialization failed. Chances are it couldn't connect to a display. Of course, Gtk doesn't put its error message anywhere I can find so we can't be more specific here ($!) ($@)";
      }
    }
  }
}

sub loop_finalize {
  my $self = shift;

  foreach my $fd (0..$#fileno_watcher) {
    next unless defined $fileno_watcher[$fd];
    foreach my $mode (MODE_RD, MODE_WR, MODE_EX) {
      POE::Kernel::_warn(
        "Mode $mode watcher for fileno $fd is defined during loop finalize"
      ) if defined $fileno_watcher[$fd]->[$mode];
    }
  }

  $self->loop_ignore_all_signals();
}

#------------------------------------------------------------------------------
# Signal handler maintenance functions.

# This function sets us up a signal when whichever window is passed to
# it closes.
sub loop_attach_uidestroy {
  my ($self, $window) = @_;

  # Don't bother posting the signal if there are no sessions left.  I
  # think this is a bit of a kludge: the situation where a window
  # lasts longer than POE::Kernel should never occur.
  $window->signal_connect(
    delete_event => sub {
      if ($self->_data_ses_count()) {
        $self->_dispatch_event
          ( $self, $self,
            EN_SIGNAL, ET_SIGNAL, [ 'UIDESTROY' ],
            __FILE__, __LINE__, undef, time(), -__LINE__
          );
      }
      return 0;
    }
  );
}

#------------------------------------------------------------------------------
# Maintain time watchers.

sub loop_resume_time_watcher {
  my ($self, $next_time) = @_;
  $next_time -= time();
  $next_time *= 1000;
  $next_time = 0 if $next_time < 0;
  $_watcher_timer = Gtk->timeout_add($next_time, \&_loop_event_callback);
}

sub loop_reset_time_watcher {
  my ($self, $next_time) = @_;
  # Should always be defined, right?
  Gtk->timeout_remove($_watcher_timer);
  undef $_watcher_timer;
  $self->loop_resume_time_watcher($next_time);
}

sub _loop_resume_timer {
  Gtk->idle_remove($_watcher_timer);
  $poe_kernel->loop_resume_time_watcher($poe_kernel->get_next_event_time());
}

sub loop_pause_time_watcher {
  # does nothing
}

#------------------------------------------------------------------------------
# Maintain filehandle watchers.

sub loop_watch_filehandle {
  my ($self, $handle, $mode) = @_;
  my $fileno = fileno($handle);

  # Overwriting a pre-existing watcher?
  if (defined $fileno_watcher[$fileno]->[$mode]) {
    Gtk::Gdk->input_remove($fileno_watcher[$fileno]->[$mode]);
    undef $fileno_watcher[$fileno]->[$mode];
  }

  if (TRACE_FILES) {
    POE::Kernel::_warn "<fh> watching $handle in mode $mode";
  }

  # Register the new watcher.
  $fileno_watcher[$fileno]->[$mode] =
    Gtk::Gdk->input_add( $fileno,
                         ( ($mode == MODE_RD)
                           ? ( 'read',
                               \&_loop_select_read_callback
                             )
                           : ( ($mode == MODE_WR)
                               ? ( 'write',
                                   \&_loop_select_write_callback
                                 )
                               : ( 'exception',
                                   \&_loop_select_expedite_callback
                                 )
                             )
                         ),
                         $fileno
                       );
}

sub loop_ignore_filehandle {
  my ($self, $handle, $mode) = @_;
  my $fileno = fileno($handle);

  if (TRACE_FILES) {
    POE::Kernel::_warn "<fh> ignoring $handle in mode $mode";
  }

  # Don't bother removing a select if none was registered.
  if (defined $fileno_watcher[$fileno]->[$mode]) {
    Gtk::Gdk->input_remove($fileno_watcher[$fileno]->[$mode]);
    undef $fileno_watcher[$fileno]->[$mode];
  }
}

sub loop_pause_filehandle {
  my ($self, $handle, $mode) = @_;
  my $fileno = fileno($handle);

  if (TRACE_FILES) {
    POE::Kernel::_warn "<fh> pausing $handle in mode $mode";
  }

  Gtk::Gdk->input_remove($fileno_watcher[$fileno]->[$mode]);
  undef $fileno_watcher[$fileno]->[$mode];
}

sub loop_resume_filehandle {
  my ($self, $handle, $mode) = @_;
  my $fileno = fileno($handle);

  # Quietly ignore requests to resume unpaused handles.
  return 1 if defined $fileno_watcher[$fileno]->[$mode];

  if (TRACE_FILES) {
    POE::Kernel::_warn "<fh> resuming $handle in mode $mode";
  }

  $fileno_watcher[$fileno]->[$mode] =
    Gtk::Gdk->input_add( $fileno,
                         ( ($mode == MODE_RD)
                           ? ( 'read',
                               \&_loop_select_read_callback
                             )
                           : ( ($mode == MODE_WR)
                               ? ( 'write',
                                   \&_loop_select_write_callback
                                 )
                               : ( 'exception',
                                   \&_loop_select_expedite_callback
                                 )
                             )
                         ),
                         $fileno
                       );
}

### Callbacks.

# Event callback to dispatch pending events.

my $last_time = time();

sub _loop_event_callback {
  my $self = $poe_kernel;

  if (TRACE_STATISTICS) {
    # TODO - I'm pretty sure the startup time will count as an unfair
    # amount of idleness.
    #
    # TODO - Introducing many new time() syscalls.  Bleah.
    $self->_data_stat_add('idle_seconds', time() - $last_time);
  }

  $self->_data_ev_dispatch_due();
  $self->_test_if_kernel_is_idle();

  Gtk->timeout_remove($_watcher_timer);
  undef $_watcher_timer;

  # Register the next timeout if there are events left.
  if ($self->get_event_count()) {
    $_watcher_timer = Gtk->idle_add(\&_loop_resume_timer);
  }

  # And back to Gtk, so we're in idle mode.
  $last_time = time() if TRACE_STATISTICS;

  # Return false to stop.
  return 0;
}

# Filehandle callback to dispatch selects.
sub _loop_select_read_callback {
  my $self = $poe_kernel;
  my ($handle, $fileno, $hash) = @_;

  if (TRACE_FILES) {
    POE::Kernel::_warn "<fh> got read callback for $handle";
  }

  $self->_data_handle_enqueue_ready(MODE_RD, $fileno);
  $self->_test_if_kernel_is_idle();

  # Return false to stop... probably not with this one.
  return 0;
}

sub _loop_select_write_callback {
  my $self = $poe_kernel;
  my ($handle, $fileno, $hash) = @_;

  if (TRACE_FILES) {
    POE::Kernel::_warn "<fh> got write callback for $handle";
  }

  $self->_data_handle_enqueue_ready(MODE_WR, $fileno);
  $self->_test_if_kernel_is_idle();

  # Return false to stop... probably not with this one.
  return 0;
}

sub _loop_select_expedite_callback {
  my $self = $poe_kernel;
  my ($handle, $fileno, $hash) = @_;

  if (TRACE_FILES) {
    POE::Kernel::_warn "<fh> got expedite callback for $handle";
  }

  $self->_data_handle_enqueue_ready(MODE_EX, $fileno);
  $self->_test_if_kernel_is_idle();

  # Return false to stop... probably not with this one.
  return 0;
}

#------------------------------------------------------------------------------
# The event loop itself.

sub loop_do_timeslice {
  die "doing timeslices currently not supported in the Gtk loop";
}

sub loop_run {
  unless (defined $_watcher_timer) {
    $_watcher_timer = Gtk->idle_add(\&_loop_resume_timer);
  }
  Gtk->main;
}

sub loop_halt {
  Gtk->main_quit();
}

1;

__END__

=head1 NAME

POE::Loop::Gtk - a bridge that allows POE to be driven by Gtk

=head1 SYNOPSIS

See L<POE::Loop>.

=head1 DESCRIPTION

POE::Loop::Gtk implements the interface documented in L<POE::Loop>.
Therefore it has no documentation of its own.  Please see L<POE::Loop>
for more details.

=head1 SEE ALSO

L<POE>, L<POE::Loop>, L<Gtk>, L<POE::Loop::PerlSignals>

=head1 AUTHORS & LICENSING

Please see L<POE> for more information about authors, contributors,
and POE's licensing.

=cut

# rocco // vim: ts=2 sw=2 expandtab
# TODO - Edit.
=pod

use strict;

use vars qw($VERSION);
$VERSION = '0.02'; # NOTE - Should be #.### (three decimal places)

use Carp qw(croak);
use Libfreenect;
use POE qw( Wheel );
use base qw(POE::Wheel);

sub SELF_STATE_READ  () { 0 }
sub SELF_STATE_WRITE () { 1 }
sub SELF_EVENT_INPUT () { 2 }
sub SELF_ID          () { 3 }
sub SELF_FREENECT    () { 4 }

sub new {
  my $type = shift;
  my %params = @_;

  croak "$type needs a working Kernel" unless defined $poe_kernel;

  my $input_event = delete $params{InputEvent};
  croak "$type requires an InputEvent parameter" unless defined $input_event;

  if (scalar keys %params) {
    carp( "unknown parameters in $type constructor call: ",
          join(', ', keys %params)
        );
  }

  # Create the object.
  my $self = bless
    [ undef,                            # SELF_STATE_READ
      undef,                            # SELF_STATE_WRITE
      $input_event,                     # SELF_EVENT_INPUT
      &POE::Wheel::allocate_wheel_id(), # SELF_ID
      Libfreenect->new,                 # SELF_FREENECT
    ];

  # XXX set up Libfreenect here
  $self->[SELF_FREENECT]->set_log_level( FREENECT_LOG_DEBUG );
  $self->[SELF_FREENECT]->num_devices > 0 or die( "No devices found!" );
  $self->[SELF_FREENECT]->open_device( 0 );
  $self->[SELF_FREENECT]->start_depth;
  $self->[SELF_FREENECT]->start_video;

$self->[SELF_FREENECT]->set_my_log_callback();

$self->[SELF_FREENECT]->process_events();

  # Define the input event.
  $self->_define_input_state();

  $self;
}

sub _define_input_state {
  my $self = shift;

  # Register the select-read handler.
  if (defined $self->[SELF_EVENT_INPUT]) {
    # Stupid closure tricks.
    my $event_input = \$self->[SELF_EVENT_INPUT];
    my $unique_id   = $self->[SELF_ID];

    $poe_kernel->state
      ( $self->[SELF_STATE_READ] = ref($self) . "($unique_id) -> select read",
        sub {

#          # Prevents SEGV in older Perls.
#          0 && CRIMSON_SCOPE_HACK('<');
#
#          my ($k, $me) = @_[KERNEL, SESSION];
#
#          # Curses' getch() normally blocks, but we've already
#          # determined that STDIN has something for us.  Be explicit
#          # about which getch() to use.
#          while ((my $keystroke = Curses::getch) ne '-1') {
#            $k->call( $me, $$event_input, $keystroke, $unique_id );
#          }
        }
      );

    # Now start reading from it.
    $poe_kernel->select_read( \*STDIN, $self->[SELF_STATE_READ] );

    # Turn blocking back on for STDIN.  Some Curses implementations
    # don't deal well with non-blocking STDIN.
#    my $flags = fcntl(STDIN, F_GETFL, 0) or die $!;
#    fcntl(STDIN, F_SETFL, $flags & ~O_NONBLOCK) or die $!;
  }
  else {
    $poe_kernel->select_read( \*STDIN );
  }
}

sub DESTROY {
  my $self = shift;

  # Turn off the select.
  $poe_kernel->select( \*STDIN );

  $self->[SELF_FREENECT]->stop_video;
  $self->[SELF_FREENECT]->stop_depth;
  $self->[SELF_FREENECT]->close_device( 0 );

  # Remove states.
  if ($self->[SELF_STATE_READ]) {
    $poe_kernel->state($self->[SELF_STATE_READ]);
    $self->[SELF_STATE_READ] = undef;
  }

#  # Restore the terminal.
#  endwin if COLS;

  &POE::Wheel::free_wheel_id($self->[SELF_ID]);
}

=cut

1;

__END__

=head1 NAME

POE::Wheel::Curses - non-blocking input for Curses

=head1 SYNOPSIS

  use Curses;
  use POE qw(Wheel::Curses);

  POE::Session->create(
    inline_states => {
      _start => sub {
        $_[HEAP]{console} = POE::Wheel::Curses->new(
          InputEvent => 'got_keystroke',
        );
      },
      got_keystroke => sub {
        my $keystroke = $_[ARG0];

        # Make control and extended keystrokes printable.
        if ($keystroke lt ' ') {
          $keystroke = '<' . uc(unctrl($keystroke)) . '>';
        }
        elsif ($keystroke =~ /^\d{2,}$/) {
          $keystroke = '<' . uc(keyname($keystroke)) . '>';
        }

        # Just display it.
        addstr($keystroke);
        noutrefresh();
        doupdate;

        # Gotta exit somehow.
        delete $_[HEAP]{console} if $keystroke eq "<^C>";
      },
    }
  );

  POE::Kernel->run();
  exit;

=head1 DESCRIPTION

POE::Wheel::Curses implements non-blocking input for Curses programs.

POE::Wheel::Curses will emit an "InputEvent" of your choosing whenever
an input event is registered on a recognized input device (keyboard
and sometimes mouse, depending on the curses library).  Meanwhile,
applications can be doing other things like monitoring network
connections or child processes, or managing timers and stuff.

=head1 PUBLIC METHODS

POE::Wheel::Curses is rather simple.

=head2 new

new() creates a new POE::Wheel::Curses object.  During construction,
the wheel registers an input watcher for STDIN (via select_read()) and
registers an internal handler to preprocess keystrokes.

new() accepts only one parameter C<InputEvent>.  C<InputEvent>
contains the name of the event that the wheel will emit whenever there
is input on the console or terminal.  As with all wheels, the event
will be sent to the session that was active when the wheel was
constructed.

It should be noted that an application may only have one active
POE::Wheel::Curses object.

=head1 EVENTS AND PARAMETERS

These are the events sent by POE::Wheel::Curses.

=head2 InputEvent

C<InputEvent> defines the event that will be emitted when
POE::Wheel::Curses detects and reads console input.  This event
includes two parameters:

C<$_[ARG0]> contains the raw keystroke as received by Curses::getch().
An application may process the keystroke using Curses::unctrl() and
Curses::keyname() on the keystroke.

C<$_[ARG1]> contains the POE::Wheel::Curses object's ID.

Mouse events aren't portable.  As of October 2009, it's up to the
application to decide whether to call mousemask().

=head1 SEE ALSO

L<Curses> documents what can be done with Curses.  Also see the man
page for whichever version of libcurses happens to be installed
(curses, ncurses, etc.).

L<POE::Wheel> describes wheels in general.

The SEE ALSO section in L<POE> contains a table of contents covering
the entire POE distribution.

=head1 BUGS

None known, although curses implementations vary widely.

=head1 AUTHORS & COPYRIGHTS

Please see L<POE> for more information about authors and contributors.

=cut

# rocco // vim: ts=2 sw=2 expandtab
# TODO - Edit.
