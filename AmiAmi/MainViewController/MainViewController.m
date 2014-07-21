//
//  MainViewController.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "MainViewController.h"

#import "MainViewController+Components.h"

@interface MainViewController ()

-(void) createNavigationRightButton;
-(void) createNavigationLeftButton;
-(void) createNavigationTitleSegment;
-(void) dataTableViewSetting;
-(void) makeReloadResultBlock;

@end

@implementation MainViewController

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - private

-(void) dataTableViewSetting {
    
    [self.dataTableView registerClass:[RankProductCell class] forCellReuseIdentifier:@"RankProductCell"];
    [self.dataTableView registerClass:[DefaultProductCell class] forCellReuseIdentifier:@"DefaultProductCell"];
    [self.dataTableView setBackgroundView:nil];
    [self.dataTableView setBackgroundColor:[UIColor clearColor]];
    
}

-(void) createNavigationRightButton {
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                 target:self
                                                                                 action:@selector(typeChangeOrReloadAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

-(void) createNavigationLeftButton {
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                                                 target:self
                                                                                 action:@selector(showSelectProductType)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}

-(void) createNavigationTitleSegment {
    
    self.typeSegment = [[UISegmentedControl alloc] initWithItems:@[@"排名", @"全部"]];
    [self.typeSegment setSelectedSegmentIndex:0];
    [self.typeSegment addTarget:self action:@selector(typeChangeOrReloadAction) forControlEvents:UIControlEventValueChanged];
    [self.typeSegment sizeToFit];
    self.navigationItem.titleView = self.typeSegment;
    
}

-(void) makeReloadResultBlock {
    
    @weakify(self);
    self.reloadRetultBlock = ^(AmiAmiParserStatus status, NSArray *result) {
        @strongify(self);
        if (status) {
            self.dataArray = result;
            [self.dataTableView reloadData];
            [self.dataTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionTop
                                              animated:YES];
        }
    };
    
}

#pragma mark - life cycle

-(void) viewDidLoad {
    
    [super viewDidLoad];

    [self dataTableViewSetting];
    [self createNavigationRightButton];
    [self createNavigationLeftButton];
    [self createNavigationTitleSegment];
    [self makeReloadResultBlock];
    
}

-(void) viewDidAppear : (BOOL) animated {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self typeChangeOrReloadAction];
    });
    
}

@end
