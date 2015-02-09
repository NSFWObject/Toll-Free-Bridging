//
//  BitVector.m
//  TollFreeBridging
//
//  Created by Sash Zats on 2/7/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

#import "BitVector.h"


@interface BitVector ()
@property (nonatomic) NSMutableArray *storage;
@end


@implementation BitVector

+ (instancetype)bitVector {
    return [[self alloc] init];
}

+ (instancetype)bitVectorWithBits:(const UInt8 *)bits count:(NSUInteger)count {
    return [[self alloc] initWithBits:bits count:count];
}

+ (instancetype)bitVectorWithArray:(NSArray *)bitsArray {
    return [[self alloc] initWithArray:bitsArray];
}

- (instancetype)init {
    return [self initWithArray:nil];
}

- (instancetype)initWithBits:(const UInt8 *)bits count:(NSUInteger)count {
    NSMutableArray *storage = [NSMutableArray array];
    for (NSUInteger i = 0; i < count; ++i) {
        Bit bit = bits[i];
        [storage addObject:@(bit)];
    }
    return [self initWithArray:storage];
}

- (instancetype)initWithArray:(NSArray *)bitsArray {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.storage = bitsArray ? [bitsArray mutableCopy] : [NSMutableArray array];
    return self;
}

#pragma mark - Public

- (NSUInteger)count {
    if (CFGetTypeID((__bridge CFTypeRef)self) == CFBitVectorGetTypeID()) {
        return CFBitVectorGetCount((__bridge CFBitVectorRef)self);
    }
    return self.storage.count;
}

- (NSUInteger)countOfBit:(Bit)bit inRange:(NSRange)range {
    if (CFGetTypeID((__bridge CFTypeRef)self) == CFBitVectorGetTypeID()) {
        return CFBitVectorGetCountOfBit((__bridge CFBitVectorRef)self, (CFRange){range.location, range.length}, bit);
    }
    
    NSAssert(NSMaxRange(range) <= self.storage.count, NSRangeException);
    
    NSUInteger counter = 0;
    for (NSNumber *number in self.storage) {
        if (number.unsignedIntValue == bit) {
            counter++;
        }
    }
    return counter;
}

- (BOOL)containsBit:(Bit)bit inRange:(NSRange)range {
    if (CFGetTypeID((__bridge CFTypeRef)self) == CFBitVectorGetTypeID()) {
        return CFBitVectorContainsBit((__bridge CFBitVectorRef)self, (CFRange){range.location, range.length}, bit);
    }

    NSAssert(NSMaxRange(range) <= self.storage.count, NSRangeException);
    
    for (NSNumber *number in self.storage) {
        if (number.unsignedIntValue == bit) {
            return YES;
        }
    }
    return NO;
}

- (Bit)bitAtIndex:(NSUInteger)index {
    NSAssert(index < self.storage.count, NSRangeException);
    
    return [self.storage[index] unsignedIntValue];
}

- (void)getBits:(out Bit *)bits inRange:(NSRange)range {
    NSAssert(NSMaxRange(range) <= self.storage.count, NSRangeException);

    bits = malloc(sizeof(Bit) * range.length);
    for (NSUInteger index = range.location; index < NSMaxRange(range); ++index) {
        bits[index - range.location] = [self.storage[index] unsignedIntValue];
    }
}

- (NSUInteger)firstIndexOfBit:(Bit)bit inRange:(NSRange)range {
    NSAssert(NSMaxRange(range) <= self.storage.count, NSRangeException);
    
    for (NSUInteger index = range.location; index < NSMaxRange(range); ++index) {
        if ([self.storage[index] unsignedIntValue] == bit) {
            return index;
        }
    }
    return NSNotFound;
}

- (NSUInteger)lastIndexOfBit:(Bit)bit inRange:(NSRange)range {
    NSAssert(NSMaxRange(range) <= self.storage.count, NSRangeException);

    for (NSUInteger index = NSMaxRange(range) - 1; index >= range.location; --index) {
        if ([self.storage[index] unsignedIntValue] == bit) {
            return index;
        }
    }
    return NSNotFound;
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@:%p> {%@}", [self class], self, [self.storage componentsJoinedByString:@","]];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
    MutableBitVector *bitVector = [[MutableBitVector allocWithZone:zone] init];
    bitVector.storage = [self.storage mutableCopy];
    return bitVector;
}

@end


@interface MutableBitVector ()
@end


@implementation MutableBitVector

#pragma mark - Public

- (void)setCount:(NSUInteger)count {
    NSInteger delta = count - self.storage.count;
    if (delta < 0) {
        [self.storage removeObjectsInRange:NSMakeRange(count, -delta)];
    } else if (delta > 0) {
        do {
            [self.storage addObject:@0];
        } while (--delta);
    }
}

- (void)flipBitAtIndex:(NSUInteger)index {
    if (CFGetTypeID((__bridge CFTypeRef)self) == CFBitVectorGetTypeID()) {
        CFBitVectorFlipBitAtIndex((__bridge CFMutableBitVectorRef)self, index);
        return;
    }
    
    NSAssert(index < self.storage.count, NSRangeException);

    self.storage[index] = @(1 - [self.storage[index] unsignedIntValue]);
}

- (void)flipBitsInRange:(NSRange)range {
    NSAssert(NSMaxRange(range) <= self.storage.count, NSRangeException);
    
    for (NSUInteger index = range.location; index < NSMaxRange(range); ++index) {
        self.storage[index] = @(1 - [self.storage[index] unsignedIntValue]);
    }
}

- (void)setBit:(Bit)bit atIndex:(NSUInteger)index {
    NSAssert(index < self.storage.count, NSRangeException);
    
    self.storage[index] = @(bit);
}

- (void)setBits:(Bit)bits inRange:(NSRange)range {
    NSAssert(NSMaxRange(range) <= self.storage.count, NSRangeException);
    
    for (NSUInteger index = range.location; index < NSMaxRange(range); ++index) {
        self.storage[index] = @(bits);
    }
}

- (void)setAllBits:(Bit)bit {
    [self setBits:bit inRange:NSMakeRange(0, self.count)];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    BitVector *bitVector = [[BitVector allocWithZone:zone] init];
    bitVector.storage = [self.storage mutableCopy];
    return bitVector;
}

@end