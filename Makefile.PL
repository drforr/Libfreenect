use 5.010001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Libfreenect',
    VERSION_FROM      => 'lib/Libfreenect.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Libfreenect.pm', # retrieve abstract from module
       AUTHOR         => 'Jeff Goff <jgoff@cpan.org>') : ()),
    LIBS              => ['-lfreenect'], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
    INC               => '-I.', # e.g., '-I. -I/usr/include/other'
	# Un-comment this if you add C files to link with later:
    # OBJECT            => '$(O_FILES)', # link all the C files too
);
if  (eval {require ExtUtils::Constant; 1}) {
  # If you edit these definitions to change the constants used by this module,
  # you will need to use the generated const-c.inc and const-xs.inc
  # files to replace their "fallback" counterparts before distributing your
  # changes.
  my @names = (qw(FREENECT_COUNTS_PER_G FREENECT_DEPTH_10BIT_PACKED_SIZE
		 FREENECT_DEPTH_10BIT_SIZE FREENECT_DEPTH_11BIT_PACKED_SIZE
		 FREENECT_DEPTH_11BIT_SIZE FREENECT_FRAME_H FREENECT_FRAME_PIX
		 FREENECT_FRAME_W FREENECT_IR_FRAME_H FREENECT_IR_FRAME_PIX
		 FREENECT_IR_FRAME_W FREENECT_VIDEO_BAYER_SIZE
		 FREENECT_VIDEO_IR_10BIT_PACKED_SIZE
		 FREENECT_VIDEO_IR_10BIT_SIZE FREENECT_VIDEO_IR_8BIT_SIZE
		 FREENECT_VIDEO_RGB_SIZE FREENECT_VIDEO_YUV_RAW_SIZE
		 FREENECT_VIDEO_YUV_RGB_SIZE),
              {name=>"FREENECT_DEPTH_10BIT", macro=>"1"},
              {name=>"FREENECT_DEPTH_10BIT_PACKED", macro=>"1"},
              {name=>"FREENECT_DEPTH_11BIT", macro=>"1"},
              {name=>"FREENECT_DEPTH_11BIT_PACKED", macro=>"1"},
              {name=>"FREENECT_LOG_DEBUG", macro=>"1"},
              {name=>"FREENECT_LOG_ERROR", macro=>"1"},
              {name=>"FREENECT_LOG_FATAL", macro=>"1"},
              {name=>"FREENECT_LOG_FLOOD", macro=>"1"},
              {name=>"FREENECT_LOG_INFO", macro=>"1"},
              {name=>"FREENECT_LOG_NOTICE", macro=>"1"},
              {name=>"FREENECT_LOG_SPEW", macro=>"1"},
              {name=>"FREENECT_LOG_WARNING", macro=>"1"},
              {name=>"FREENECT_VIDEO_BAYER", macro=>"1"},
              {name=>"FREENECT_VIDEO_IR_10BIT", macro=>"1"},
              {name=>"FREENECT_VIDEO_IR_10BIT_PACKED", macro=>"1"},
              {name=>"FREENECT_VIDEO_IR_8BIT", macro=>"1"},
              {name=>"FREENECT_VIDEO_RGB", macro=>"1"},
              {name=>"FREENECT_VIDEO_YUV_RAW", macro=>"1"},
              {name=>"FREENECT_VIDEO_YUV_RGB", macro=>"1"},
              {name=>"LED_BLINK_GREEN", macro=>"1"},
              {name=>"LED_BLINK_RED_YELLOW", macro=>"1"},
              {name=>"LED_BLINK_YELLOW", macro=>"1"},
              {name=>"LED_GREEN", macro=>"1"},
              {name=>"LED_OFF", macro=>"1"},
              {name=>"LED_RED", macro=>"1"},
              {name=>"LED_YELLOW", macro=>"1"},
              {name=>"TILT_STATUS_LIMIT", macro=>"1"},
              {name=>"TILT_STATUS_MOVING", macro=>"1"},
              {name=>"TILT_STATUS_STOPPED", macro=>"1"});
  ExtUtils::Constant::WriteConstants(
                                     NAME         => 'Libfreenect',
                                     NAMES        => \@names,
                                     DEFAULT_TYPE => 'IV',
                                     C_FILE       => 'const-c.inc',
                                     XS_FILE      => 'const-xs.inc',
                                  );

}
else {
  use File::Copy;
  use File::Spec;
  foreach my $file ('const-c.inc', 'const-xs.inc') {
    my $fallback = File::Spec->catfile('fallback', $file);
    copy ($fallback, $file) or die "Can't copy $fallback to $file: $!";
  }
}
