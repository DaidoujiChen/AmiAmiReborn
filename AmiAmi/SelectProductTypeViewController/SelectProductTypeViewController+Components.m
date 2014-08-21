//
//  SelectProductTypeViewController+Components.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/4/9.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "SelectProductTypeViewController+Components.h"

@implementation SelectProductTypeViewController (Components)

- (void)dismissSelf
{
    @weakify(self);
	[self dismissViewControllerAnimated:YES completion: ^{
        @strongify(self);
	    self.requestReloadTable();
	}];
}

@end
