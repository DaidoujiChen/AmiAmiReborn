//
//  AmiAmiParser+Parser.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/3/19.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AmiAmiParser.h"

@interface AmiAmiParser (Parser)
+(void) rankProductsParser : (UIWebView*) webView;
+(void) allProductsParser : (UIWebView*) webView;
+(void) productInfoParser : (UIWebView*) webView;
@end
