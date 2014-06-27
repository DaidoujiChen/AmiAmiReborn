//
//  MainViewController+Components.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/4/9.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "MainViewController+Components.h"

@implementation MainViewController (Components)

#pragma mark - instance method

-(void) typeChangeOrReloadAction {
    switch (typeSegment.selectedSegmentIndex) {
        case 0:
            [self loadRankData];
            break;
        case 1:
            [self loadAllProductsData];
            break;
        default:
            break;
    }
}

-(void) showSelectProductType {
    
    UINavigationController *navi = [UINavigationController new];
    SelectProductTypeViewController *next = [SelectProductTypeViewController new];
    [next setRequestReloadTable:^{
        [self typeChangeOrReloadAction];
    }];
    [navi pushViewController:next animated:NO];
    [self presentViewController:navi animated:YES completion:^{
    }];
    
}

#pragma mark - private

-(void) loadAllProductsData {
    [AmiAmiParser parseAllProducts:reloadRetultBlock];
}

-(void) loadRankData {
    [AmiAmiParser parseRankProducts:reloadRetultBlock];
}

@end
