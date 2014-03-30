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
            if (([[NSDate date] timeIntervalSince1970] - [[self startDate] timeIntervalSince1970]) > 25.0f && [self passAlertView] == nil) {
                UIAlertView *passAlertView = [[UIAlertView alloc] initWithTitle:@"這個作品有可能沒有相關商品"
                                                                        message:@"是否直接秀出現有資料?"
                                                                       delegate:self
                                                              cancelButtonTitle:@"我再等等..."
                                                              otherButtonTitles:@"秀吧!", nil];
                [passAlertView show];
                [self setPassAlertView:passAlertView];
            }
            
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
