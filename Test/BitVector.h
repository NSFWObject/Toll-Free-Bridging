//
//  BitVector.h
//  Test
//
//  Created by Sash Zats on 2/7/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef CFBit Bit;


@interface BitVector : NSObject <NSCopying, NSMutableCopying>

+ (instancetype)bitVector;

@property (nonatomic, readonly) NSUInteger count;

- (NSUInteger)countOfBit:(Bit)bit inRange:(NSRange)range;

- (BOOL)containsBit:(Bit)bit inRange:(NSRange)range;

- (Bit)bitAtIndex:(NSUInteger)index;

- (void)getBits:(Bit *)bits inRange:(NSRange)range;

- (NSUInteger)firstIndexOfBit:(Bit)bit inRange:(NSRange)range;

- (NSUInteger)lastIndexOfBit:(Bit)bit inRange:(NSRange)range;

@end


@interface MutableBitVector : BitVector

@property (nonatomic) NSUInteger count;

- (void)flipBitAtIndex:(NSUInteger)index;

- (void)flipBitsInRange:(NSRange)range;

- (void)setBit:(Bit)bit atIndex:(NSUInteger)index;

- (void)setBits:(Bit)bits inRange:(NSRange)range;

- (void)setAllBits:(Bit)bit;

@end