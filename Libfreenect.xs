#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <libfreenect.h>

#include "const-c.inc"

MODULE = Libfreenect		PACKAGE = Libfreenect		

INCLUDE: const-xs.inc

void
hello()
	CODE:
		printf( "Hello, world!\n" );

void *
init()
	CODE:
		void * f_ctx;
		printf( "Initializing freenect!\n" );
		int result = freenect_init( &f_ctx, NULL );
		if ( result == -1 )
			RETVAL = result;
		else
			RETVAL = f_ctx;
	OUTPUT:
		RETVAL

void
set_log_level()
	CODE:
		printf( "Setting freenect logging level!\n" );

int
num_devices()
	CODE:
		printf( "Returning device count!\n" );
		RETVAL = -1;
	OUTPUT:
		RETVAL
