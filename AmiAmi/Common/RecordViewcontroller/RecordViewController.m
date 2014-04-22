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
    
    [self.dataTableView registerClass:[RelationCell class] forCellReuseIdentifier:@"RelationCell"];
    [self.dataTableView setBackgroundView:nil];
    [self.dataTableView setBackgroundColor:[UIColor clearColor]];
    
}

#pragma mark - life cycle

-(void) viewDidLoad {
    
    [super viewDidLoad];
    [self dataTableViewSetting];
    
    [[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        [self.dataTableView reloadData];
    }];
}

@end