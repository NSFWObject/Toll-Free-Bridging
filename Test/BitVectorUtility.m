//
//  BitVectorUtility.m
//  TollFreeBridging
//
//  Created by Sash Zats on 2/8/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

#import "BitVectorUtility.h"

#import "BitVector.h"
#import "fishhook.h"
#import <dlfcn.h>


extern void _CFRuntimeBridgeClasses(CFTypeID cfType, const char *className);
static CFIndex (*_CFBitVectorGetCount)(CFBitVectorRef bv);

@implementation BitVectorUtility

+ (instancetype)sharedUtility {
    static BitVectorUtility *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BitVectorUtility alloc] init];
    });
    return instance;
}

#pragma mark - Public

- (void)regsiterBitVector {
    [self _registerCoreFoundation];
    [self _registerObjectiveC];
}

#pragma mark - Private

- (void)_registerCoreFoundation {
    _CFBitVectorGetCount = dlsym(RTLD_DEFAULT, "CFBitVectorGetCount");
    
}

- (void)_registerObjectiveC {
    // This line tells to the Objective-C runtime,
    // if message sent to CFBitVector, forward it to BitVector
    _CFRuntimeBridgeClasses(CFBitVectorGetTypeID(), "BitVector");
}

@end
