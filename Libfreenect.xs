#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <libfreenect.h>
#include <libfreenect_sync.h>

#include "const-c.inc"

void my_callback( void* dev, int level, const char* msg ) {
  printf( "%s\n", msg );
}

MODULE = Libfreenect		PACKAGE = Libfreenect		

INCLUDE: const-xs.inc

void*
init()
	CODE:
		void* f_ctx;
		int result = freenect_init( &f_ctx, NULL );
		// XXX FIXME DAMNIT
		if ( result == -1 )
			RETVAL = result;
		else
			RETVAL = f_ctx;
	OUTPUT:
		RETVAL

int
shutdown( void* f_ctx )
	CODE:
		RETVAL = freenect_shutdown( f_ctx );
	OUTPUT:
		RETVAL

void
_set_log_level( void* f_ctx, int level )
	CODE:
		freenect_set_log_level( f_ctx, (freenect_loglevel) level );

int
_num_devices( void* f_ctx )
	CODE:
		RETVAL = freenect_num_devices( f_ctx );
	OUTPUT:
		RETVAL

void*
_open_device ( void* f_ctx, int user_device_number )
	CODE:
		void* f_dev;
		int ret_val = freenect_open_device( f_ctx, &f_dev, user_device_number );
		if ( ret_val < 0 )
			RETVAL = ret_val;
		else
			RETVAL = f_dev;
	OUTPUT:
		RETVAL

void*
_close_device ( void* f_dev )
	CODE:
		RETVAL = freenect_close_device( f_dev );
	OUTPUT:
		RETVAL

int
_set_led( void* f_dev, int option )
	CODE:
		RETVAL = freenect_set_led( f_dev, option );
	OUTPUT:
		RETVAL

int
_process_events( void* f_ctx )
	CODE:
		RETVAL = freenect_process_events( f_ctx );
	OUTPUT:
		RETVAL

int
_start_depth( void* f_dev )
	CODE:
		RETVAL = freenect_start_depth( f_dev );
	OUTPUT:
		RETVAL

int
_stop_depth( void* f_dev )
	CODE:
		RETVAL = freenect_stop_depth( f_dev );
	OUTPUT:
		RETVAL

int
_start_video( void* f_dev )
	CODE:
		RETVAL = freenect_start_video( f_dev );
	OUTPUT:
		RETVAL

int
_stop_video( void* f_dev )
	CODE:
		RETVAL = freenect_stop_video( f_dev );
	OUTPUT:
		RETVAL

int
_update_tilt_state( void* f_dev )
	CODE:
		RETVAL = freenect_update_tilt_state( f_dev );
	OUTPUT:
		RETVAL

void*
_get_tilt_state( void* f_dev )
	CODE:
		RETVAL = freenect_get_tilt_state( f_dev );
	OUTPUT:
		RETVAL

void*
_get_user( void* f_dev )
	CODE:
		RETVAL = freenect_get_user( f_dev );
	OUTPUT:
		RETVAL

void
_set_user( void* f_dev, void* user )
	CODE:
		freenect_set_user( f_dev, user );

void*
_set_depth_format( void* f_dev, int fmt )
	CODE:
		RETVAL = freenect_set_depth_format( f_dev, fmt );
	OUTPUT:
		RETVAL

void*
_set_video_format( void* f_dev, int fmt )
	CODE:
		RETVAL = freenect_set_video_format( f_dev, fmt );
	OUTPUT:
		RETVAL

int
_set_depth_buffer( void* f_dev, void* buf )
	CODE:
		RETVAL = freenect_set_depth_buffer( f_dev, buf );
	OUTPUT:
		RETVAL

int
_set_video_buffer( void* f_dev, void* buf )
	CODE:
		RETVAL = freenect_set_video_buffer( f_dev, buf );
	OUTPUT:
		RETVAL

int
_set_tilt_degs( void* f_dev, double angle )
	CODE:
		RETVAL = freenect_set_tilt_degs( f_dev, angle );
	OUTPUT:
		RETVAL

void*
_malloc_buffer( )
	CODE:
		RETVAL = malloc( 640 * 480 * 3 );
	OUTPUT:
		RETVAL

void
_free_buffer( void* buffer )
	CODE:
		free( buffer );

char
_get_buffer_value( char * buffer, int idx )
	CODE:
		RETVAL = buffer[idx];
	OUTPUT:
		RETVAL

void
_set_log_callback( void* ctx, void* cb )
	CODE:
		freenect_set_log_callback( ctx, cb );

void
_set_my_log_callback( void* ctx )
	CODE:
		freenect_set_log_callback( ctx, &my_callback );
