//
//  SelectProductTypeViewController+Components.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/4/9.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "SelectProductTypeViewController+Components.h"

@implementation SelectProductTypeViewController (Components)

-(void) dismissSelf {
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.requestReloadTable();
    }];
    
}

@end
