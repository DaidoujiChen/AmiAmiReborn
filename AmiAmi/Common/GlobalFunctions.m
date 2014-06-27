//
//  GlobalFunctions.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/23.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "GlobalFunctions.h"

@implementation GlobalFunctions

+(NSString*) fixProductURL : (NSString*) oriURL {
    NSRange findRange = [oriURL rangeOfString:@"http://"];
    
    if (findRange.location == NSNotFound) {
        return [NSString stringWithFormat:@"http://www.amiami.jp%@", oriURL];
    } else {
        return oriURL;
    }
}

+(void) imageEffect : (UIView*) view {
    view.layer.masksToBounds = NO;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.borderWidth = 3.5f;
    view.layer.contentsScale = [UIScreen mainScreen].scale;
    /*view.layer.shadowOpacity = 0.75f;
    view.layer.shadowRadius = 5.0f;
    view.layer.shadowOffset = CGSizeZero;
    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    view.layer.shouldRasterize = YES;*/
}

+(void) textEffect : (UIView*) view {
    /*view.layer.shadowColor = [[UIColor whiteColor] CGColor];
    view.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    view.layer.shadowOpacity = 1.0f;
    view.layer.shadowRadius = 1.0f;*/
}

+(void) addToHistory : (NSDictionary*) productInfo {
    if ([LWPArray(@"History") count] >= 20) {
        [LWPArray(@"History") removeObjectAtIndex:0];
    }
    
    for (NSDictionary *eachInfo in LWPArray(@"History")) {
        if ([[eachInfo objectForKey:@"URL"] isEqualToString:[productInfo objectForKey:@"URL"]]) {
            [LWPArray(@"History") removeObject:eachInfo];
            break;
        }
    }
    
    [LWPArray(@"History") addObject:productInfo];
}

+(void) addToFavorite {
    [SVProgressHUD showSuccessWithStatus:@"添加成功"];
    
    NSDictionary *productInfo = [LWPArray(@"History") lastObject];
    
    for (NSDictionary *eachInfo in LWPArray(@"Favorite")) {
        if ([[eachInfo objectForKey:@"URL"] isEqualToString:[productInfo objectForKey:@"URL"]]) {
            [LWPArray(@"Favorite") removeObject:eachInfo];
            break;
        }
    }
    
    [LWPArray(@"Favorite") addObject:[LWPArray(@"History") lastObject]];
}

@end
