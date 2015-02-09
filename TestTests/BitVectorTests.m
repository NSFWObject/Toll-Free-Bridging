//
//  TestTests.m
//  TestTests
//
//  Created by Sash Zats on 2/7/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "BitVector.h"
#import "BitVectorUtility.h"

@interface BitVectorTests : XCTestCase
@property (nonatomic) CFBitVectorRef cfBitVector;
@property (nonatomic) BitVector *bitVector;
@end

@implementation BitVectorTests

+ (void)setUp {
    [super setUp];
    
    [[BitVectorUtility sharedUtility] enableBitVectorBridging];
}

- (void)setUp {
    [super setUp];
    
    UInt8 sample = 255;
    self.cfBitVector = CFBitVectorCreate(kCFAllocatorDefault, (const UInt8 *)&sample, 8);
    
    UInt8 mySample[8] = {1,1,1,1,1,1,1,1};
    self.bitVector = [[BitVector alloc] initWithBits:mySample count:8];
}

- (void)testCount {
    XCTAssertEqual(CFBitVectorGetCount(self.cfBitVector), ((__bridge BitVector *)self.cfBitVector).count);
    XCTAssertEqual(CFBitVectorGetCount((__bridge CFBitVectorRef)self.bitVector), self.bitVector.count);
}

- (void)testCountOfBits {
    XCTAssertEqual(CFBitVectorGetCountOfBit(self.cfBitVector, CFRangeMake(0, CFBitVectorGetCount(self.cfBitVector)), 1),
                   [(__bridge BitVector *)self.cfBitVector countOfBit:1 inRange:NSMakeRange(0, CFBitVectorGetCount(self.cfBitVector))]);
    
    XCTAssertEqual(CFBitVectorGetCountOfBit((__bridge CFBitVectorRef)self.bitVector, (CFRange){0, self.bitVector.count}, 1),
                   [self.bitVector countOfBit:1 inRange:NSMakeRange(0, self.bitVector.count)]);
}

- (void)testContainsBit {
    XCTAssertEqual(CFBitVectorContainsBit(self.cfBitVector, CFRangeMake(0, CFBitVectorGetCount(self.cfBitVector)), 1),
                   [(__bridge BitVector *)self.cfBitVector containsBit:1 inRange:NSMakeRange(0, CFBitVectorGetCount(self.cfBitVector))]);

    XCTAssertEqual(CFBitVectorContainsBit((__bridge CFBitVectorRef)self.bitVector, (CFRange){0, self.bitVector.count}, 1),
                   [self.bitVector containsBit:1 inRange:NSMakeRange(0, self.bitVector.count)]);
}

@end
