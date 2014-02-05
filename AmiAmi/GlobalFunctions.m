//
//  GlobalFunctions.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/23.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "GlobalFunctions.h"

@implementation GlobalFunctions

+(NSString*) specProductStringFromThumbnail : (NSString*) thumbnailString {
    NSArray *splitArray = [thumbnailString componentsSeparatedByString:@"/"];
    
    NSString *finalString = [splitArray objectAtIndex:[splitArray count]-1];
    
    NSArray *finalArray = [finalString componentsSeparatedByString:@"."];

    return [NSString stringWithFormat:@"http://www.amiami.jp/top/detail/detail?scode=%@", [finalArray objectAtIndex:0]];
}

+(void) imageEffect : (UIView*) view {
    view.layer.masksToBounds = NO;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.borderWidth = 3.5f;
    view.layer.contentsScale = [UIScreen mainScreen].scale;
    view.layer.shadowOpacity = 0.75f;
    view.layer.shadowRadius = 5.0f;
    view.layer.shadowOffset = CGSizeZero;
    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    view.layer.shouldRasterize = YES;
}

+(void) textEffect : (UIView*) view {
    view.layer.shadowColor = [[UIColor whiteColor] CGColor];
    view.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    view.layer.shadowOpacity = 1.0f;
    view.layer.shadowRadius = 1.0f;
}

@end
