//
//  AmiAmiParser+MiscFunctions.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/3/19.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AmiAmiParser.h"

@interface AmiAmiParser (MiscFunctions)

#pragma mark - use in Parser
+(NSMutableDictionary*) parshThumbnailWithTitle : (TFHppleElement*) element;
+(void) freeMemory;
+(NSString*) mergeContentTexts : (TFHppleElement*) content;

#pragma mark - use in AmiAmiParser
+(UIWebView*) makeParseWebViewWithURL : (NSURL*) parseURL;
+(void) parse : (NSTimer*) timer;

@end
