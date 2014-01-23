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

@end
