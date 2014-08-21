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

- (void)typeChangeOrReloadAction
{
	if (self.typeSegment.selectedSegmentIndex) {
		[self loadAllProductsData];
	} else {
		[self loadRankData];
	}
}

- (void)showSelectProductType
{
	UINavigationController *navi = [UINavigationController new];
	SelectProductTypeViewController *next = [SelectProductTypeViewController new];
	@weakify(self);
    next.requestReloadTable = ^{
	    @strongify(self);
	    [self typeChangeOrReloadAction];
	};
	[navi pushViewController:next animated:NO];
	[self presentViewController:navi animated:YES completion: ^{
	}];
}

#pragma mark - private

- (void)loadAllProductsData
{
	[AmiAmiParser parseAllProducts:self.reloadRetultBlock];
}

- (void)loadRankData
{
	[AmiAmiParser parseRankProducts:self.reloadRetultBlock];
}

@end
