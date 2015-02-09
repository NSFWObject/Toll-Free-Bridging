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
CFIndex __CFBitVectorGetCount(CFBitVectorRef bv) {
    if (CFGetTypeID(bv) == CFBitVectorGetTypeID()) {
        return _CFBitVectorGetCount(bv);
    }
    return [(__bridge BitVector *)bv count];
}

static CFIndex (*_CFBitVectorGetCountOfBit)(CFBitVectorRef bv, CFRange range, CFBit value);
CFIndex __CFBitVectorGetCountOfBit(CFBitVectorRef bv, CFRange range, CFBit value) {
    if (CFGetTypeID(bv) == CFBitVectorGetTypeID()) {
        return _CFBitVectorGetCountOfBit(bv, range, value);
    }
    return [(__bridge BitVector *)bv countOfBit:value inRange:(NSRange){range.location, range.length}];
}

static Boolean(*_CFBitVectorContainsBit)(CFBitVectorRef bv, CFRange range, CFBit value);
Boolean	__CFBitVectorContainsBit(CFBitVectorRef bv, CFRange range, CFBit value) {
    if (CFGetTypeID(bv) == CFBitVectorGetTypeID()) {
        return _CFBitVectorContainsBit(bv, range, value);
    }
    return [(__bridge BitVector *)bv containsBit:value inRange:(NSRange){range.location, range.length}];
}

static void(*_CFBitVectorFlipBitAtIndex)(CFMutableBitVectorRef bv, CFIndex idx);
void __CFBitVectorFlipBitAtIndex(CFMutableBitVectorRef bv, CFIndex idx) {
    if (CFGetTypeID(bv) == CFBitVectorGetTypeID()) {
        return _CFBitVectorFlipBitAtIndex(bv, idx);
    }
    [(__bridge MutableBitVector *)bv flipBitAtIndex:idx];
}

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

- (void)enableBitVectorBridging {
    [self _registerCoreFoundation];
    [self _registerObjectiveC];
}

#pragma mark - Private

- (void)_registerCoreFoundation {
    // CFBitVectorGetCount
    _CFBitVectorGetCount = dlsym(RTLD_DEFAULT, "CFBitVectorGetCount");
    rebind_symbols((struct rebinding[1]){{"CFBitVectorGetCount", __CFBitVectorGetCount}}, 1);

    // CFBitVectorGetCountOfBit
    _CFBitVectorGetCountOfBit = dlsym(RTLD_DEFAULT, "CFBitVectorGetCountOfBit");
    rebind_symbols((struct rebinding[1]){{"CFBitVectorGetCountOfBit", __CFBitVectorGetCountOfBit}}, 1);
    
    // CFBitVectorContainsBit
    _CFBitVectorContainsBit = dlsym(RTLD_DEFAULT, "CFBitVectorContainsBit");
    rebind_symbols((struct rebinding[1]){{"CFBitVectorContainsBit", __CFBitVectorContainsBit}}, 1);
    
    // CFBitVectorFlipBitAtIndex
    _CFBitVectorFlipBitAtIndex = dlsym(RTLD_DEFAULT, "CFBitVectorFlipBitAtIndex");
    rebind_symbols((struct rebinding[1]){{"CFBitVectorFlipBitAtIndex", __CFBitVectorFlipBitAtIndex}}, 1);
}

- (void)_registerObjectiveC {
    // This line tells to the Objective-C runtime,
    // if message sent to CFBitVector, forward it to BitVector
    _CFRuntimeBridgeClasses(CFBitVectorGetTypeID(), "MutableBitVector");
}

@end
