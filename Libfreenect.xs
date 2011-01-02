#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <libfreenect>

#include "const-c.inc"

MODULE = Libfreenect		PACKAGE = Libfreenect		

INCLUDE: const-xs.inc
