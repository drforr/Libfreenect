#define PERL_constant_NOTFOUND	1
#define PERL_constant_NOTDEF	2
#define PERL_constant_ISIV	3
#define PERL_constant_ISNO	4
#define PERL_constant_ISNV	5
#define PERL_constant_ISPV	6
#define PERL_constant_ISPVN	7
#define PERL_constant_ISSV	8
#define PERL_constant_ISUNDEF	9
#define PERL_constant_ISUV	10
#define PERL_constant_ISYES	11

#ifndef NVTYPE
typedef double NV; /* 5.6 and later define NVTYPE, and typedef NV to it.  */
#endif
#ifndef aTHX_
#define aTHX_ /* 5.6 or later define this for threading support.  */
#endif
#ifndef pTHX_
#define pTHX_ /* 5.6 or later define this for threading support.  */
#endif

static int
constant_16 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     FREENECT_FRAME_H FREENECT_FRAME_W LED_BLINK_YELLOW */
  /* Offset 2 gives the best switch position.  */
  switch (name[2]) {
  case 'D':
    if (memEQ(name, "LED_BLINK_YELLOW", 16)) {
    /*                 ^                    */
      *iv_return = LED_BLINK_YELLOW;
      return PERL_constant_ISIV;
    }
    break;
  case 'E':
    if (memEQ(name, "FREENECT_FRAME_H", 16)) {
    /*                 ^                    */
#ifdef FREENECT_FRAME_H
      *iv_return = FREENECT_FRAME_H;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "FREENECT_FRAME_W", 16)) {
    /*                 ^                    */
#ifdef FREENECT_FRAME_W
      *iv_return = FREENECT_FRAME_W;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_17 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     FREENECT_LOG_INFO FREENECT_LOG_SPEW TILT_STATUS_LIMIT */
  /* Offset 14 gives the best switch position.  */
  switch (name[14]) {
  case 'M':
    if (memEQ(name, "TILT_STATUS_LIMIT", 17)) {
    /*                             ^         */
      *iv_return = TILT_STATUS_LIMIT;
      return PERL_constant_ISIV;
    }
    break;
  case 'N':
    if (memEQ(name, "FREENECT_LOG_INFO", 17)) {
    /*                             ^         */
      *iv_return = FREENECT_LOG_INFO;
      return PERL_constant_ISIV;
    }
    break;
  case 'P':
    if (memEQ(name, "FREENECT_LOG_SPEW", 17)) {
    /*                             ^         */
      *iv_return = FREENECT_LOG_SPEW;
      return PERL_constant_ISIV;
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_18 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     FREENECT_FRAME_PIX FREENECT_LOG_DEBUG FREENECT_LOG_ERROR
     FREENECT_LOG_FATAL FREENECT_LOG_FLOOD FREENECT_VIDEO_RGB
     TILT_STATUS_MOVING */
  /* Offset 15 gives the best switch position.  */
  switch (name[15]) {
  case 'B':
    if (memEQ(name, "FREENECT_LOG_DEBUG", 18)) {
    /*                              ^         */
      *iv_return = FREENECT_LOG_DEBUG;
      return PERL_constant_ISIV;
    }
    break;
  case 'I':
    if (memEQ(name, "TILT_STATUS_MOVING", 18)) {
    /*                              ^         */
      *iv_return = TILT_STATUS_MOVING;
      return PERL_constant_ISIV;
    }
    break;
  case 'O':
    if (memEQ(name, "FREENECT_LOG_FLOOD", 18)) {
    /*                              ^         */
      *iv_return = FREENECT_LOG_FLOOD;
      return PERL_constant_ISIV;
    }
    break;
  case 'P':
    if (memEQ(name, "FREENECT_FRAME_PIX", 18)) {
    /*                              ^         */
#ifdef FREENECT_FRAME_PIX
      *iv_return = FREENECT_FRAME_PIX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "FREENECT_LOG_ERROR", 18)) {
    /*                              ^         */
      *iv_return = FREENECT_LOG_ERROR;
      return PERL_constant_ISIV;
    }
    if (memEQ(name, "FREENECT_VIDEO_RGB", 18)) {
    /*                              ^         */
      *iv_return = FREENECT_VIDEO_RGB;
      return PERL_constant_ISIV;
    }
    break;
  case 'T':
    if (memEQ(name, "FREENECT_LOG_FATAL", 18)) {
    /*                              ^         */
      *iv_return = FREENECT_LOG_FATAL;
      return PERL_constant_ISIV;
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_19 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     FREENECT_IR_FRAME_H FREENECT_IR_FRAME_W FREENECT_LOG_NOTICE
     TILT_STATUS_STOPPED */
  /* Offset 18 gives the best switch position.  */
  switch (name[18]) {
  case 'D':
    if (memEQ(name, "TILT_STATUS_STOPPE", 18)) {
    /*                                 D      */
      *iv_return = TILT_STATUS_STOPPED;
      return PERL_constant_ISIV;
    }
    break;
  case 'E':
    if (memEQ(name, "FREENECT_LOG_NOTIC", 18)) {
    /*                                 E      */
      *iv_return = FREENECT_LOG_NOTICE;
      return PERL_constant_ISIV;
    }
    break;
  case 'H':
    if (memEQ(name, "FREENECT_IR_FRAME_", 18)) {
    /*                                 H      */
#ifdef FREENECT_IR_FRAME_H
      *iv_return = FREENECT_IR_FRAME_H;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'W':
    if (memEQ(name, "FREENECT_IR_FRAME_", 18)) {
    /*                                 W      */
#ifdef FREENECT_IR_FRAME_W
      *iv_return = FREENECT_IR_FRAME_W;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_20 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     FREENECT_DEPTH_10BIT FREENECT_DEPTH_11BIT FREENECT_LOG_WARNING
     FREENECT_VIDEO_BAYER LED_BLINK_RED_YELLOW */
  /* Offset 16 gives the best switch position.  */
  switch (name[16]) {
  case '0':
    if (memEQ(name, "FREENECT_DEPTH_10BIT", 20)) {
    /*                               ^          */
      *iv_return = FREENECT_DEPTH_10BIT;
      return PERL_constant_ISIV;
    }
    break;
  case '1':
    if (memEQ(name, "FREENECT_DEPTH_11BIT", 20)) {
    /*                               ^          */
      *iv_return = FREENECT_DEPTH_11BIT;
      return PERL_constant_ISIV;
    }
    break;
  case 'A':
    if (memEQ(name, "FREENECT_VIDEO_BAYER", 20)) {
    /*                               ^          */
      *iv_return = FREENECT_VIDEO_BAYER;
      return PERL_constant_ISIV;
    }
    break;
  case 'L':
    if (memEQ(name, "LED_BLINK_RED_YELLOW", 20)) {
    /*                               ^          */
      *iv_return = LED_BLINK_RED_YELLOW;
      return PERL_constant_ISIV;
    }
    break;
  case 'N':
    if (memEQ(name, "FREENECT_LOG_WARNING", 20)) {
    /*                               ^          */
      *iv_return = FREENECT_LOG_WARNING;
      return PERL_constant_ISIV;
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_22 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     FREENECT_VIDEO_IR_8BIT FREENECT_VIDEO_YUV_RAW FREENECT_VIDEO_YUV_RGB */
  /* Offset 20 gives the best switch position.  */
  switch (name[20]) {
  case 'A':
    if (memEQ(name, "FREENECT_VIDEO_YUV_RAW", 22)) {
    /*                                   ^        */
      *iv_return = FREENECT_VIDEO_YUV_RAW;
      return PERL_constant_ISIV;
    }
    break;
  case 'G':
    if (memEQ(name, "FREENECT_VIDEO_YUV_RGB", 22)) {
    /*                                   ^        */
      *iv_return = FREENECT_VIDEO_YUV_RGB;
      return PERL_constant_ISIV;
    }
    break;
  case 'I':
    if (memEQ(name, "FREENECT_VIDEO_IR_8BIT", 22)) {
    /*                                   ^        */
      *iv_return = FREENECT_VIDEO_IR_8BIT;
      return PERL_constant_ISIV;
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_25 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     FREENECT_DEPTH_10BIT_SIZE FREENECT_DEPTH_11BIT_SIZE
     FREENECT_VIDEO_BAYER_SIZE */
  /* Offset 16 gives the best switch position.  */
  switch (name[16]) {
  case '0':
    if (memEQ(name, "FREENECT_DEPTH_10BIT_SIZE", 25)) {
    /*                               ^               */
#ifdef FREENECT_DEPTH_10BIT_SIZE
      *iv_return = FREENECT_DEPTH_10BIT_SIZE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '1':
    if (memEQ(name, "FREENECT_DEPTH_11BIT_SIZE", 25)) {
    /*                               ^               */
#ifdef FREENECT_DEPTH_11BIT_SIZE
      *iv_return = FREENECT_DEPTH_11BIT_SIZE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'A':
    if (memEQ(name, "FREENECT_VIDEO_BAYER_SIZE", 25)) {
    /*                               ^               */
#ifdef FREENECT_VIDEO_BAYER_SIZE
      *iv_return = FREENECT_VIDEO_BAYER_SIZE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_27 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     FREENECT_DEPTH_10BIT_PACKED FREENECT_DEPTH_11BIT_PACKED
     FREENECT_VIDEO_IR_8BIT_SIZE FREENECT_VIDEO_YUV_RAW_SIZE
     FREENECT_VIDEO_YUV_RGB_SIZE */
  /* Offset 21 gives the best switch position.  */
  switch (name[21]) {
  case 'B':
    if (memEQ(name, "FREENECT_VIDEO_YUV_RGB_SIZE", 27)) {
    /*                                    ^            */
#ifdef FREENECT_VIDEO_YUV_RGB_SIZE
      *iv_return = FREENECT_VIDEO_YUV_RGB_SIZE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "FREENECT_DEPTH_10BIT_PACKED", 27)) {
    /*                                    ^            */
      *iv_return = FREENECT_DEPTH_10BIT_PACKED;
      return PERL_constant_ISIV;
    }
    if (memEQ(name, "FREENECT_DEPTH_11BIT_PACKED", 27)) {
    /*                                    ^            */
      *iv_return = FREENECT_DEPTH_11BIT_PACKED;
      return PERL_constant_ISIV;
    }
    break;
  case 'T':
    if (memEQ(name, "FREENECT_VIDEO_IR_8BIT_SIZE", 27)) {
    /*                                    ^            */
#ifdef FREENECT_VIDEO_IR_8BIT_SIZE
      *iv_return = FREENECT_VIDEO_IR_8BIT_SIZE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'W':
    if (memEQ(name, "FREENECT_VIDEO_YUV_RAW_SIZE", 27)) {
    /*                                    ^            */
#ifdef FREENECT_VIDEO_YUV_RAW_SIZE
      *iv_return = FREENECT_VIDEO_YUV_RAW_SIZE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant (pTHX_ const char *name, STRLEN len, IV *iv_return) {
  /* Initially switch on the length of the name.  */
  /* When generated this function returned values for the list of names given
     in this section of perl code.  Rather than manually editing these functions
     to add or remove constants, which would result in this comment and section
     of code becoming inaccurate, we recommend that you edit this section of
     code, and use it to regenerate a new set of constant functions which you
     then use to replace the originals.

     Regenerate these constant functions by feeding this entire source file to
     perl -x

#!/usr/bin/perl -w
use ExtUtils::Constant qw (constant_types C_constant XS_constant);

my $types = {map {($_, 1)} qw(IV)};
my @names = (qw(FREENECT_COUNTS_PER_G FREENECT_DEPTH_10BIT_PACKED_SIZE
	       FREENECT_DEPTH_10BIT_SIZE FREENECT_DEPTH_11BIT_PACKED_SIZE
	       FREENECT_DEPTH_11BIT_SIZE FREENECT_FRAME_H FREENECT_FRAME_PIX
	       FREENECT_FRAME_W FREENECT_IR_FRAME_H FREENECT_IR_FRAME_PIX
	       FREENECT_IR_FRAME_W FREENECT_VIDEO_BAYER_SIZE
	       FREENECT_VIDEO_IR_10BIT_PACKED_SIZE FREENECT_VIDEO_IR_10BIT_SIZE
	       FREENECT_VIDEO_IR_8BIT_SIZE FREENECT_VIDEO_RGB_SIZE
	       FREENECT_VIDEO_YUV_RAW_SIZE FREENECT_VIDEO_YUV_RGB_SIZE),
            {name=>"FREENECT_DEPTH_10BIT", type=>"IV", macro=>"1"},
            {name=>"FREENECT_DEPTH_10BIT_PACKED", type=>"IV", macro=>"1"},
            {name=>"FREENECT_DEPTH_11BIT", type=>"IV", macro=>"1"},
            {name=>"FREENECT_DEPTH_11BIT_PACKED", type=>"IV", macro=>"1"},
            {name=>"FREENECT_LOG_DEBUG", type=>"IV", macro=>"1"},
            {name=>"FREENECT_LOG_ERROR", type=>"IV", macro=>"1"},
            {name=>"FREENECT_LOG_FATAL", type=>"IV", macro=>"1"},
            {name=>"FREENECT_LOG_FLOOD", type=>"IV", macro=>"1"},
            {name=>"FREENECT_LOG_INFO", type=>"IV", macro=>"1"},
            {name=>"FREENECT_LOG_NOTICE", type=>"IV", macro=>"1"},
            {name=>"FREENECT_LOG_SPEW", type=>"IV", macro=>"1"},
            {name=>"FREENECT_LOG_WARNING", type=>"IV", macro=>"1"},
            {name=>"FREENECT_VIDEO_BAYER", type=>"IV", macro=>"1"},
            {name=>"FREENECT_VIDEO_IR_10BIT", type=>"IV", macro=>"1"},
            {name=>"FREENECT_VIDEO_IR_10BIT_PACKED", type=>"IV", macro=>"1"},
            {name=>"FREENECT_VIDEO_IR_8BIT", type=>"IV", macro=>"1"},
            {name=>"FREENECT_VIDEO_RGB", type=>"IV", macro=>"1"},
            {name=>"FREENECT_VIDEO_YUV_RAW", type=>"IV", macro=>"1"},
            {name=>"FREENECT_VIDEO_YUV_RGB", type=>"IV", macro=>"1"},
            {name=>"LED_BLINK_GREEN", type=>"IV", macro=>"1"},
            {name=>"LED_BLINK_RED_YELLOW", type=>"IV", macro=>"1"},
            {name=>"LED_BLINK_YELLOW", type=>"IV", macro=>"1"},
            {name=>"LED_GREEN", type=>"IV", macro=>"1"},
            {name=>"LED_OFF", type=>"IV", macro=>"1"},
            {name=>"LED_RED", type=>"IV", macro=>"1"},
            {name=>"LED_YELLOW", type=>"IV", macro=>"1"},
            {name=>"TILT_STATUS_LIMIT", type=>"IV", macro=>"1"},
            {name=>"TILT_STATUS_MOVING", type=>"IV", macro=>"1"},
            {name=>"TILT_STATUS_STOPPED", type=>"IV", macro=>"1"});

print constant_types(), "\n"; # macro defs
foreach (C_constant ("Libfreenect", 'constant', 'IV', $types, undef, 3, @names) ) {
    print $_, "\n"; # C constant subs
}
print "\n#### XS Section:\n";
print XS_constant ("Libfreenect", $types);
__END__
   */

  switch (len) {
  case 7:
    /* Names all of length 7.  */
    /* LED_OFF LED_RED */
    /* Offset 5 gives the best switch position.  */
    switch (name[5]) {
    case 'E':
      if (memEQ(name, "LED_RED", 7)) {
      /*                    ^       */
        *iv_return = LED_RED;
        return PERL_constant_ISIV;
      }
      break;
    case 'F':
      if (memEQ(name, "LED_OFF", 7)) {
      /*                    ^       */
        *iv_return = LED_OFF;
        return PERL_constant_ISIV;
      }
      break;
    }
    break;
  case 9:
    if (memEQ(name, "LED_GREEN", 9)) {
      *iv_return = LED_GREEN;
      return PERL_constant_ISIV;
    }
    break;
  case 10:
    if (memEQ(name, "LED_YELLOW", 10)) {
      *iv_return = LED_YELLOW;
      return PERL_constant_ISIV;
    }
    break;
  case 15:
    if (memEQ(name, "LED_BLINK_GREEN", 15)) {
      *iv_return = LED_BLINK_GREEN;
      return PERL_constant_ISIV;
    }
    break;
  case 16:
    return constant_16 (aTHX_ name, iv_return);
    break;
  case 17:
    return constant_17 (aTHX_ name, iv_return);
    break;
  case 18:
    return constant_18 (aTHX_ name, iv_return);
    break;
  case 19:
    return constant_19 (aTHX_ name, iv_return);
    break;
  case 20:
    return constant_20 (aTHX_ name, iv_return);
    break;
  case 21:
    /* Names all of length 21.  */
    /* FREENECT_COUNTS_PER_G FREENECT_IR_FRAME_PIX */
    /* Offset 13 gives the best switch position.  */
    switch (name[13]) {
    case 'R':
      if (memEQ(name, "FREENECT_IR_FRAME_PIX", 21)) {
      /*                            ^              */
#ifdef FREENECT_IR_FRAME_PIX
        *iv_return = FREENECT_IR_FRAME_PIX;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'T':
      if (memEQ(name, "FREENECT_COUNTS_PER_G", 21)) {
      /*                            ^              */
#ifdef FREENECT_COUNTS_PER_G
        *iv_return = FREENECT_COUNTS_PER_G;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 22:
    return constant_22 (aTHX_ name, iv_return);
    break;
  case 23:
    /* Names all of length 23.  */
    /* FREENECT_VIDEO_IR_10BIT FREENECT_VIDEO_RGB_SIZE */
    /* Offset 20 gives the best switch position.  */
    switch (name[20]) {
    case 'B':
      if (memEQ(name, "FREENECT_VIDEO_IR_10BIT", 23)) {
      /*                                   ^         */
        *iv_return = FREENECT_VIDEO_IR_10BIT;
        return PERL_constant_ISIV;
      }
      break;
    case 'I':
      if (memEQ(name, "FREENECT_VIDEO_RGB_SIZE", 23)) {
      /*                                   ^         */
#ifdef FREENECT_VIDEO_RGB_SIZE
        *iv_return = FREENECT_VIDEO_RGB_SIZE;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 25:
    return constant_25 (aTHX_ name, iv_return);
    break;
  case 27:
    return constant_27 (aTHX_ name, iv_return);
    break;
  case 28:
    if (memEQ(name, "FREENECT_VIDEO_IR_10BIT_SIZE", 28)) {
#ifdef FREENECT_VIDEO_IR_10BIT_SIZE
      *iv_return = FREENECT_VIDEO_IR_10BIT_SIZE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 30:
    if (memEQ(name, "FREENECT_VIDEO_IR_10BIT_PACKED", 30)) {
      *iv_return = FREENECT_VIDEO_IR_10BIT_PACKED;
      return PERL_constant_ISIV;
    }
    break;
  case 32:
    /* Names all of length 32.  */
    /* FREENECT_DEPTH_10BIT_PACKED_SIZE FREENECT_DEPTH_11BIT_PACKED_SIZE */
    /* Offset 16 gives the best switch position.  */
    switch (name[16]) {
    case '0':
      if (memEQ(name, "FREENECT_DEPTH_10BIT_PACKED_SIZE", 32)) {
      /*                               ^                      */
#ifdef FREENECT_DEPTH_10BIT_PACKED_SIZE
        *iv_return = FREENECT_DEPTH_10BIT_PACKED_SIZE;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case '1':
      if (memEQ(name, "FREENECT_DEPTH_11BIT_PACKED_SIZE", 32)) {
      /*                               ^                      */
#ifdef FREENECT_DEPTH_11BIT_PACKED_SIZE
        *iv_return = FREENECT_DEPTH_11BIT_PACKED_SIZE;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 35:
    if (memEQ(name, "FREENECT_VIDEO_IR_10BIT_PACKED_SIZE", 35)) {
#ifdef FREENECT_VIDEO_IR_10BIT_PACKED_SIZE
      *iv_return = FREENECT_VIDEO_IR_10BIT_PACKED_SIZE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

