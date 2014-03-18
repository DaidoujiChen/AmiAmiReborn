//
//  AmiAmiParser.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AmiAmiParser.h"

#import "AmiAmiParser+AccessObjects.h"
#import "AmiAmiParser+MiscFunctions.h"

@implementation AmiAmiParser

+(void) parseAllProducts : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion {
    [self setStartDate:[NSDate date]];
    [self setPassFlag:NO];
    
    NSDictionary *eachDictionary = [LWPArray(@"AllProducts") objectAtIndex:[[LWPDictionary(@"MISC") objectForKey:@"typeIndex"] intValue]];
    
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"讀取最新%@商品...", [eachDictionary objectForKey:@"title"]]
                         maskType:SVProgressHUDMaskTypeBlack];
    [self setArrayCompletion:completion];
    [self setEntryType:AmiAmiParserEntryTypeAll];
    [self setParseWebView:[self makeParseWebViewWithURL:[NSURL URLWithString:[eachDictionary objectForKey:@"allproducts"]]]];
}

+(void) parseRankProducts : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion {
    [self setStartDate:[NSDate date]];
    [self setPassFlag:NO];
    
    NSDictionary *eachDictionary = [LWPArray(@"AllProducts") objectAtIndex:[[LWPDictionary(@"MISC") objectForKey:@"typeIndex"] intValue]];

    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"讀取%@排行商品...", [eachDictionary objectForKey:@"title"]]
                         maskType:SVProgressHUDMaskTypeBlack];
    [self setArrayCompletion:completion];
    [self setEntryType:AmiAmiParserEntryTypeRank];
    [self setParseWebView:[self makeParseWebViewWithURL:[NSURL URLWithString:@"http://www.amiami.jp/top/page/c/ranking.html"]]];
}

+(void) parseProductInfo : (NSString*) urlString completion : (void (^)(AmiAmiParserStatus status, NSDictionary *result)) completion {
    [self setStartDate:[NSDate date]];
    [self setPassFlag:NO];
    [SVProgressHUD showWithStatus:@"讀取商品內容..." maskType:SVProgressHUDMaskTypeBlack];
    [self setDictionaryCompletion:completion];
    [self setEntryType:AmiAmiParserEntryTypeProductInfo];
    [self setParseWebView:[self makeParseWebViewWithURL:[NSURL URLWithString:urlString]]];
}

@end
