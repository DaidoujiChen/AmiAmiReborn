//
//  AmiAmiParser+HandleUIWebViewDelegate.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/3/19.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AmiAmiParser+HandleUIWebViewDelegate.h"

#import "AmiAmiParser+AccessObjects.h"
#import "AmiAmiParser+Parser.h"

@implementation AmiAmiParser (HandleUIWebViewDelegate)

+(void) webViewDidFinishLoad : (UIWebView*) webView {
    
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

+(void) webView : (UIWebView*) webView didFailLoadWithError : (NSError*) error {
    NSLog(@"someone fail : %@", error);
}

@end
