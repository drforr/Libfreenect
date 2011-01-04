#!/usr/bin/perl -w

package POE::Wheel::Kinect;

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
