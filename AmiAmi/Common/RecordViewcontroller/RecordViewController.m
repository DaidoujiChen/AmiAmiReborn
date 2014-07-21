//
//  RecordViewController.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/4/7.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()
-(void) dataTableViewSetting;
@end

@implementation RecordViewController

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private

-(void) dataTableViewSetting {
    
    [self.dataTableView registerClass:[DefaultProductCell class] forCellReuseIdentifier:@"DefaultProductCell"];
    [self.dataTableView setBackgroundView:nil];
    [self.dataTableView setBackgroundColor:[UIColor clearColor]];
    
}

#pragma mark - life cycle

-(void) viewDidLoad {
    [super viewDidLoad];
    
    [self dataTableViewSetting];

}

-(void) viewWillAppear : (BOOL) animated {
    [super viewWillAppear:animated];
    
    [self.dataTableView reloadData];
    
}

@end
