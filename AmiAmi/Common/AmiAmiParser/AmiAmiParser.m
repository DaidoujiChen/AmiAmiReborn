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
#import "AmiAmiParser+Parser.h"

@implementation AmiAmiParser

+(void) parseAllProducts : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion {
    [self setTimeout];
    [self setPassFlag:NO];
    
    NSDictionary *eachDictionary = [LWPArray(@"AllProducts") objectAtIndex:[[LWPDictionary(@"MISC") objectForKey:@"typeIndex"] intValue]];
    
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"讀取最新%@商品...", [eachDictionary objectForKey:@"title"]]
                         maskType:SVProgressHUDMaskTypeBlack];
    [self setArrayCompletion:completion];
    [self setEntryType:AmiAmiParserEntryTypeAll];
    [self setParseWebView:[self makeParseWebViewWithURL:[NSURL URLWithString:[eachDictionary objectForKey:@"allproducts"]]]];
    [self startWebViewTimer];
}

+(void) parseRankProducts : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion {
    [self setTimeout];
    [self setPassFlag:NO];
    
    NSDictionary *eachDictionary = [LWPArray(@"AllProducts") objectAtIndex:[[LWPDictionary(@"MISC") objectForKey:@"typeIndex"] intValue]];

    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"讀取%@排行商品...", [eachDictionary objectForKey:@"title"]]
                         maskType:SVProgressHUDMaskTypeBlack];
    [self setArrayCompletion:completion];
    [self setEntryType:AmiAmiParserEntryTypeRank];
    [self setParseWebView:[self makeParseWebViewWithURL:[NSURL URLWithString:@"http://www.amiami.jp/top/page/c/ranking.html"]]];
    [self startWebViewTimer];
}

+(void) parseProductInfo : (NSString*) urlString completion : (void (^)(AmiAmiParserStatus status, NSDictionary *result)) completion {
    [self setTimeout];
    [self setPassFlag:NO];
    [SVProgressHUD showWithStatus:@"讀取商品內容..." maskType:SVProgressHUDMaskTypeBlack];
    [self setDictionaryCompletion:completion];
    [self setEntryType:AmiAmiParserEntryTypeProductInfo];
    [self setParseWebView:[self makeParseWebViewWithURL:[NSURL URLWithString:urlString]]];
    [self startWebViewTimer];
}

#pragma mark - private

+(void) startWebViewTimer {
    
    if (![self webViewTimer]) {
        
        [self setWebViewTimer:[DispatchTimer scheduledOnMainThreadAfterDelay:1.5f timeInterval:1.5f block:^{
            if ([[self parseLock] tryLock]) {
                switch ([self entryType]) {
                    case AmiAmiParserEntryTypeRank:
                        [self rankProductsParser:[self parseWebView]];
                        break;
                    case AmiAmiParserEntryTypeAll:
                        [self allProductsParser:[self parseWebView]];
                        break;
                    case AmiAmiParserEntryTypeProductInfo:
                        [self productInfoParser:[self parseWebView]];
                        break;
                }
            }
        }]];
        
    }
}

@end
