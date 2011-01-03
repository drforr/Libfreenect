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
		// XXX FIXME DAMNIT
		if ( result == -1 )
			RETVAL = result;
		else
			RETVAL = f_ctx;
	OUTPUT:
		RETVAL

int
shutdown( void * f_ctx )
	CODE:
		RETVAL = freenect_shutdown( f_ctx );
	OUTPUT:
		RETVAL

void
_set_log_level( void * f_ctx, int level )
	CODE:
		printf( "Setting freenect logging level!\n" );
		freenect_set_log_level( f_ctx, (freenect_loglevel) level );

int
_num_devices( void * f_ctx )
	CODE:
		printf( "Returning device count!\n" );
		RETVAL = freenect_num_devices( f_ctx );
	OUTPUT:
		RETVAL

void *
_open_device ( void * f_ctx, int user_device_number )
	CODE:
		void * f_dev;
		int ret_val = freenect_open_device( f_ctx, &f_dev, user_device_number );
		if ( ret_val < 0 )
			RETVAL = ret_val;
		else
			RETVAL = f_dev;
	OUTPUT:
		RETVAL

void *
_close_device ( void * f_dev )
	CODE:
		RETVAL = freenect_close_device( f_dev );
	OUTPUT:
		RETVAL
