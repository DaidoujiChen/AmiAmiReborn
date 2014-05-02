//
//  AmiAmiParser+MiscFunctions.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/3/19.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AmiAmiParser+MiscFunctions.h"

#import "AmiAmiParser+AccessObjects.h"

@implementation AmiAmiParser (MiscFunctions)

+(UIWebView*) makeParseWebViewWithURL : (NSURL*) parseURL {
    UIWebView *parserWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [parserWebView setDelegate:(id<UIWebViewDelegate>)self];
    [parserWebView loadRequest:[NSURLRequest requestWithURL:parseURL]];
    return parserWebView;
}

+(void) setTimeout {
    
    self.objects.timeoutTimer = [DispatchTimer scheduledOnMainThreadOnceAfterDelay:25.0f block:^{
        if (self.objects.passAlertView == nil) {
            UIAlertView *passAlertView = [[UIAlertView alloc] initWithTitle:@"這個作品有可能沒有相關商品"
                                                                    message:@"是否直接秀出現有資料?"
                                                                   delegate:self
                                                          cancelButtonTitle:@"我再等等..."
                                                          otherButtonTitles:@"秀吧!", nil];
            [passAlertView show];
            self.objects.passAlertView = passAlertView;
        }
    }];
    
}

@end
