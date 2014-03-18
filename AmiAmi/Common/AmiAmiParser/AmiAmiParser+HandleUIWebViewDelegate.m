//
//  AmiAmiParser+HandleUIWebViewDelegate.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/3/19.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AmiAmiParser+HandleUIWebViewDelegate.h"

#import "AmiAmiParser+AccessObjects.h"
#import "AmiAmiParser+MiscFunctions.h"

@implementation AmiAmiParser (HandleUIWebViewDelegate)

+(void) webViewDidFinishLoad : (UIWebView*) webView {
    
    if (![self webViewTimer]) {
        [self setWebViewTimer:[NSTimer scheduledTimerWithTimeInterval:1.5f
                                                               target:self
                                                             selector:@selector(parse:)
                                                             userInfo:nil
                                                              repeats:YES]];
    }
    
}

+(void) webView : (UIWebView*) webView didFailLoadWithError : (NSError*) error {
    NSLog(@"someone fail : %@", error);
}

@end
