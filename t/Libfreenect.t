use Test::More tests => 4;
BEGIN { use_ok('Libfreenect') };

my $fail = 0;
foreach my $constname (qw(
	FREENECT_COUNTS_PER_G FREENECT_DEPTH_10BIT FREENECT_DEPTH_10BIT_PACKED
	FREENECT_DEPTH_10BIT_PACKED_SIZE FREENECT_DEPTH_10BIT_SIZE
	FREENECT_DEPTH_11BIT FREENECT_DEPTH_11BIT_PACKED
	FREENECT_DEPTH_11BIT_PACKED_SIZE FREENECT_DEPTH_11BIT_SIZE
	FREENECT_FRAME_H FREENECT_FRAME_PIX FREENECT_FRAME_W
	FREENECT_IR_FRAME_H FREENECT_IR_FRAME_PIX FREENECT_IR_FRAME_W
	FREENECT_LOG_DEBUG FREENECT_LOG_ERROR FREENECT_LOG_FATAL
	FREENECT_LOG_FLOOD FREENECT_LOG_INFO FREENECT_LOG_NOTICE
	FREENECT_LOG_SPEW FREENECT_LOG_WARNING FREENECT_VIDEO_BAYER
	FREENECT_VIDEO_BAYER_SIZE FREENECT_VIDEO_IR_10BIT
	FREENECT_VIDEO_IR_10BIT_PACKED FREENECT_VIDEO_IR_10BIT_PACKED_SIZE
	FREENECT_VIDEO_IR_10BIT_SIZE FREENECT_VIDEO_IR_8BIT
	FREENECT_VIDEO_IR_8BIT_SIZE FREENECT_VIDEO_RGB FREENECT_VIDEO_RGB_SIZE
	FREENECT_VIDEO_YUV_RAW FREENECT_VIDEO_YUV_RAW_SIZE
	FREENECT_VIDEO_YUV_RGB FREENECT_VIDEO_YUV_RGB_SIZE LED_BLINK_GREEN
	LED_BLINK_RED_YELLOW LED_BLINK_YELLOW LED_GREEN LED_OFF LED_RED
	LED_YELLOW TILT_STATUS_LIMIT TILT_STATUS_MOVING TILT_STATUS_STOPPED)) {
  next if (eval "my \$a = $constname; 1");
  if ($@ =~ /^Your vendor has not defined Libfreenect macro $constname/) {
    print "# pass: $@";
  } else {
    print "# fail: $@";
    $fail = 1;
  }
}

ok( $fail == 0 , 'Constants' );

my $lib = Libfreenect->new;
$lib->set_log_level( FREENECT_LOG_DEBUG );
$lib->num_devices > 0 or BAIL_OUT( "No devices found!" );
$lib->open_device( 0 );
$lib->set_video_format( FREENECT_VIDEO_RGB );
$lib->set_depth_format( FREENECT_DEPTH_11BIT );
$lib->start_depth;
$lib->start_video;

$lib->update_tilt_state;
my @tilt = $lib->get_tilt_state;
my @accel = $lib->get_mks_accel;
ok( $tilt[0] != 0 );
ok( $accel[0] != 0 );

$lib->set_led( LED_RED );
sleep(1);
#$lib->set_tilt_degs( -1 );
#sleep(1);
#$lib->set_tilt_degs( 0 );
sleep(1);
$lib->set_led( LED_OFF );

$lib->stop_video;
$lib->stop_depth;
$lib->close_device( 0 );
$lib->shutdown or die "Unclean shutdown\n";
