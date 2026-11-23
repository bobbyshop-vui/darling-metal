// SPDX-FileCopyrightText: 2026 Darling Developers
// SPDX-License-Identifier: MPL-2.0

#import <Foundation/NSObject.h>
#import <Foundation/NSMethodSignature.h>
#import <Foundation/NSInvocation.h>

@interface MTLFunctionConstantValues : NSObject
@end

@implementation MTLFunctionConstantValues

#if DARLING_METAL_ENABLED

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [NSMethodSignature signatureWithObjCTypes: "v@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSLog(@"Stub called: %@ in %@", NSStringFromSelector([anInvocation selector]), [self class]);
}

#endif

@end
