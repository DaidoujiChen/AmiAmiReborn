//
//  AmiAmiParser+MiscFunctions.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/3/19.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AmiAmiParser.h"

@interface AmiAmiParser (MiscFunctions)

#pragma mark - use in AmiAmiParser
+ (UIWebView *)makeParseWebViewWithURL:(NSURL *)parseURL;

#pragma mark - use in AmiAmiParser, HandleUIAlertViewDelegate
+ (void)setTimeout;

@end
