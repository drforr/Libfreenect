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
	OUTPUT:
		f_ctx
