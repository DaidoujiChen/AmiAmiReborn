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

+(void) parseAllProducts : (ArrayCompletion) completion {
    [self setTimeout];
    self.objects.passFlag = NO;
    
    NSDictionary *eachDictionary = [LWPArray(@"AllProducts") objectAtIndex:[[LWPDictionary(@"MISC") objectForKey:@"typeIndex"] intValue]];
    
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"讀取最新%@商品...", [eachDictionary objectForKey:@"title"]]
                         maskType:SVProgressHUDMaskTypeBlack];
    self.objects.arrayCompletion = completion;
    self.objects.entryType = AmiAmiParserEntryTypeAll;
    self.objects.parseWebView = [self makeParseWebViewWithURL:[NSURL URLWithString:[eachDictionary objectForKey:@"allproducts"]]];
    [self startWebViewTimer];
}

+(void) parseRankProducts : (ArrayCompletion) completion {
    [self setTimeout];
    self.objects.passFlag = NO;
    
    NSDictionary *eachDictionary = [LWPArray(@"AllProducts") objectAtIndex:[[LWPDictionary(@"MISC") objectForKey:@"typeIndex"] intValue]];

    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"讀取%@排行商品...", [eachDictionary objectForKey:@"title"]]
                         maskType:SVProgressHUDMaskTypeBlack];
    self.objects.arrayCompletion = completion;
    self.objects.entryType = AmiAmiParserEntryTypeRank;
    self.objects.parseWebView = [self makeParseWebViewWithURL:[NSURL URLWithString:@"http://www.amiami.jp/top/page/c/ranking.html"]];
    [self startWebViewTimer];
}

+(void) parseProductInfo : (NSString*) urlString completion : (DictionaryCompletion) completion {
    [self setTimeout];
    self.objects.passFlag = NO;
    [SVProgressHUD showWithStatus:@"讀取商品內容..." maskType:SVProgressHUDMaskTypeBlack];
    self.objects.dictionaryCompletion = completion;
    self.objects.entryType = AmiAmiParserEntryTypeProductInfo;
    self.objects.parseWebView = [self makeParseWebViewWithURL:[NSURL URLWithString:urlString]];
    [self startWebViewTimer];
}

#pragma mark - private

+(void) startWebViewTimer {
    
    if (!self.objects.webViewTimer) {
        
        self.objects.webViewTimer = [DispatchTimer scheduledOnMainThreadAfterDelay:1.5f timeInterval:1.5f block:^{
            if ([self.objects.parseLock tryLock]) {
                switch (self.objects.entryType) {
                    case AmiAmiParserEntryTypeRank:
                        [self rankProductsParser:self.objects.parseWebView];
                        break;
                    case AmiAmiParserEntryTypeAll:
                        [self allProductsParser:self.objects.parseWebView];
                        break;
                    case AmiAmiParserEntryTypeProductInfo:
                        [self productInfoParser:self.objects.parseWebView];
                        break;
                }
            }
        }];
    }
    
}

@end
