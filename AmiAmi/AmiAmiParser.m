//
//  AmiAmiParser.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AmiAmiParser.h"

#import <objc/runtime.h>

@interface AmiAmiParser (Private)
+(NSMutableArray*) webviewLoadsArray;
@end

@implementation AmiAmiParser

static const char PARSEWEBVIEWPOINTER;
static const char WEBVIEWLOADSCOUNT;
static const char COMPLETIONPOINTER;

#pragma mark - private

+(NSMutableArray*) webviewLoadsArray {
    
    NSMutableArray *array = objc_getAssociatedObject(self, &WEBVIEWLOADSCOUNT);
    
    if (array == nil) {
        array = [NSMutableArray array];
        objc_setAssociatedObject(self, &WEBVIEWLOADSCOUNT, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return array;
}

#pragma mark - UIWebViewDelegate

+ (void)webViewDidStartLoad:(UIWebView *)webView {
    [[self webviewLoadsArray] addObject:[NSObject new]];
}

+ (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[self webviewLoadsArray] removeLastObject];
    
    if ([[self webviewLoadsArray] count] > 0) {
        return;
    } else {
        NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        
        NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
        
        TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
        NSArray *elements = [doc searchWithXPathQuery:@"//div [@class='productranking category2']//img"];
        
        if ([elements count] == 0) {
            return;
        }
        
        NSMutableArray *returnArray = [NSMutableArray array];
        
        for (TFHppleElement *e in elements) {
            NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
            [dictionaryInArray setObject:[e objectForKey:@"src"] forKey:@"Thumbnail"];
            [dictionaryInArray setObject:[e objectForKey:@"alt"] forKey:@"Title"];
            [returnArray addObject:dictionaryInArray];
        }
        
        void (^completion)(AmiAmiParserStatus status, NSArray *result) = objc_getAssociatedObject(self, &COMPLETIONPOINTER);
        completion(AmiAmiParserStatusSuccess, returnArray);
    }
}

+ (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[self webviewLoadsArray] removeLastObject];
}

#pragma mark - class methods

+(void) parseRankCategory : (int) categoryNumber completion : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion {
    objc_setAssociatedObject(self, &COMPLETIONPOINTER, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    UIWebView *parserWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [parserWebView setDelegate:(id<UIWebViewDelegate>)self];
    [parserWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.amiami.jp/top/page/c/ranking.html"]]];
    objc_setAssociatedObject(self, &PARSEWEBVIEWPOINTER, parserWebView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
