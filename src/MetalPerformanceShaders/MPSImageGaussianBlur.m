// SPDX-FileCopyrightText: 2026 Darling Developers
// SPDX-License-Identifier: MPL-2.0

#import <Foundation/NSObject.h>
#import <Foundation/NSMethodSignature.h>
#import <Foundation/NSInvocation.h>

/*
 * Real MPSImageGaussianBlur derives from MPSKernel, but a plain NSObject
 * stub is enough for dyld to resolve the class symbol.
 */
@interface MPSImageGaussianBlur : NSObject
@end

@implementation MPSImageGaussianBlur

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
	return [NSMethodSignature signatureWithObjCTypes: "v@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
	NSLog(@"Stub called: %@ in %@", NSStringFromSelector([anInvocation selector]), [self class]);
}

@end
