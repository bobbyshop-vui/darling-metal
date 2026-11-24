#import <Foundation/Foundation.h>

/* Model I/O and Metal vertex descriptor conversion are unavailable in the
 * current MetalKit implementation. */
id MTKMetalVertexDescriptorFromModelIOWithError(id modelIODescriptor, NSError **error)
{
	(void) modelIODescriptor;
	if (error != NULL)
		*error = nil;
	return nil;
}

id MTKModelIOVertexDescriptorFromMetalWithError(id metalDescriptor, NSError **error)
{
	(void) metalDescriptor;
	if (error != NULL)
		*error = nil;
	return nil;
}
