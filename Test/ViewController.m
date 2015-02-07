//
//  ViewController.m
//  TollFreeBridging
//
//  Created by Sash Zats on 2/7/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

#import "ViewController.h"

#import "BitVectorUtility.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[BitVectorUtility sharedUtility] regsiterBitVector];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
