#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

/* The private pixel-format info record is seven 64-bit words in the Xcode 10
 * ABI. Darling has no Metal device backend from which to fill those fields. */
typedef struct {
	uint64_t words[7];
} DarlingMTLPixelFormatInfo;

extern "C" {

DarlingMTLPixelFormatInfo MTLPixelFormatGetInfo(uint64_t pixelFormat)
{
	(void) pixelFormat;
	DarlingMTLPixelFormatInfo result = {{0, 0, 0, 0, 0, 0, 0}};
	return result;
}

bool MTLValidationEnabled(void)
{
	return getenv("METAL_INDIUM_VALIDATION") != NULL;
}

void *getShaderCachePath(void)
{
	return NULL;
}

}
