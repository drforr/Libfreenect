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
