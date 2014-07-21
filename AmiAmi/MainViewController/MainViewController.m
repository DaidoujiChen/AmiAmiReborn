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
@property (nonatomic, strong) NSArray *dataArray;

-(void) createNavigationRightButton;
-(void) createNavigationLeftButton;
-(void) createNavigationTitleSegment;
-(void) dataTableViewSetting;
-(void) makeReloadResultBlock;

@end

@implementation MainViewController

@synthesize dataArray;

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - private

#pragma mark ui create

-(void) dataTableViewSetting {
    
    [self.dataTableView registerClass:[MainCell class] forCellReuseIdentifier:@"MainCell"];
    [self.dataTableView registerClass:[RelationCell class] forCellReuseIdentifier:@"RelationCell"];
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
    
    typeSegment = [[UISegmentedControl alloc] initWithItems:@[@"排名", @"全部"]];
    [typeSegment setSelectedSegmentIndex:0];
    [typeSegment addTarget:self action:@selector(typeChangeOrReloadAction) forControlEvents:UIControlEventValueChanged];
    [typeSegment sizeToFit];
    self.navigationItem.titleView = typeSegment;
    
}

-(void) makeReloadResultBlock {
    
    @weakify(self);
    reloadRetultBlock = ^(AmiAmiParserStatus status, NSArray *result) {
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
