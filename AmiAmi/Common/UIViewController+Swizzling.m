//
//  UIViewController+Swizzling.m
//  MaShuShuV2
//
//  Created by 啟倫 陳 on 2014/2/27.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "UIViewController+Swizzling.h"

@implementation UIViewController (Swizzling)

+(void) load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
           [self jr_swizzleMethod:@selector(prefersStatusBarHidden) withMethod:@selector(swizzling_prefersStatusBarHidden) error:nil];
    });
}

-(BOOL) swizzling_prefersStatusBarHidden {
    return YES;
}

@end
