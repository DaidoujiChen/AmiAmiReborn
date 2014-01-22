//
//  SpecProductViewController.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/22.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "SpecProductViewController.h"

@interface SpecProductViewController ()

@end

@implementation SpecProductViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - hidden status bar

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated {
    [self.view setBackgroundColor:[UIColor clearColor]];
}

-(void) viewWillDisappear:(BOOL)animated {
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

@end
