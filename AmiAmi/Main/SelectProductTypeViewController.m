//
//  SelectProductTypeViewController.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/3/10.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "SelectProductTypeViewController.h"

#import "SelectProductTypeViewController+Components.h"

@interface SelectProductTypeViewController ()
-(void) createNavigationRightButton;
-(void) selectProductTypeTableViewSetting;
@end

@implementation SelectProductTypeViewController

@synthesize requestReloadTable;

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private

-(void) createNavigationRightButton {
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                 target:nil
                                                                                 action:nil];
    
    rightButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self dismissSelf];
        return [RACSignal empty];
    }];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

-(void) selectProductTypeTableViewSetting {
    [self.selectProductTypeTableView registerClass:[DefaultCell class] forCellReuseIdentifier:@"DefaultCell"];
}

#pragma mark - life cycle

-(void) viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationRightButton];
    [self selectProductTypeTableViewSetting];
}

@end
