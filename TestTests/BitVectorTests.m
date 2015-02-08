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
    
    UInt8 cfBits[2] = {0,1};
    self.cfBitVector = CFBitVectorCreate(kCFAllocatorDefault, cfBits, 2);
    
    Bit bits[3] = {1,0,1};
    self.bitVector = [[BitVector alloc] initWithBits:bits count:3];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCount {
    XCTAssertEqual(CFBitVectorGetCount(self.cfBitVector), [(__bridge BitVector *)self.cfBitVector count]);
    XCTAssertEqual(CFBitVectorGetCount((__bridge CFBitVectorRef)self.bitVector), [self.bitVector count]);
}

- (void)testCountOfBits {
    XCTAssertEqual(CFBitVectorGetCountOfBit(self.cfBitVector, CFRangeMake(0, CFBitVectorGetCount(self.cfBitVector)), 1), [(__bridge BitVector *)self.cfBitVector countOfBit:1 inRange:NSMakeRange(0, CFBitVectorGetCount(self.cfBitVector))]);
    XCTAssertEqual(CFBitVectorGetCountOfBit((__bridge CFBitVectorRef)self.bitVector, CFRangeMake(0, self.bitVector.count), 1), [self.bitVector countOfBit:1 inRange:NSMakeRange(0, self.bitVector.count)]);
}

@end
¿¿