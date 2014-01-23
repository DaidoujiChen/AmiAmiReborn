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
+ (void)rankParser:(UIWebView *)webView;
+ (void)specProductParser:(UIWebView *)webView;
+(void) setEntryType : (AmiAmiParserEntryType) entryType;
+(AmiAmiParserEntryType) entryType;
@end

@implementation AmiAmiParser

static const char ENTRYTYPEPOINTER;
static const char PARSEWEBVIEWPOINTER;
static const char WEBVIEWLOADSCOUNT;
static const char COMPLETIONPOINTER;

#pragma mark - private

+(void) setEntryType : (AmiAmiParserEntryType) entryType {
    objc_setAssociatedObject(self, &ENTRYTYPEPOINTER, [NSNumber numberWithInt:entryType], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(AmiAmiParserEntryType) entryType {
    NSNumber *entry = objc_getAssociatedObject(self, &ENTRYTYPEPOINTER);
    return [entry intValue];
}

+(NSMutableArray*) webviewLoadsArray {
    
    NSMutableArray *array = objc_getAssociatedObject(self, &WEBVIEWLOADSCOUNT);
    
    if (array == nil) {
        array = [NSMutableArray array];
        objc_setAssociatedObject(self, &WEBVIEWLOADSCOUNT, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return array;
}

+ (void)relationProductParser:(UIWebView *)webView {
    NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *relationElements = [doc searchWithXPathQuery:@"//div [@class='logrecom_places']//img"];
    
    if ([relationElements count] == 0) {
        [[self webviewLoadsArray] removeAllObjects];
        [webView reload];
        return;
    }

    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
    
    NSMutableArray *relationArray = [NSMutableArray array];
    
    for (TFHppleElement *e in relationElements) {
        NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
        [dictionaryInArray setObject:[e objectForKey:@"src"] forKey:@"Thumbnail"];
        [dictionaryInArray setObject:[e objectForKey:@"alt"] forKey:@"Title"];
        [relationArray addObject:dictionaryInArray];
    }
    
    NSArray *popularElements = [doc searchWithXPathQuery:@"//div [@class='ichioshi']//img"];
    
    NSMutableArray *popularArray = [NSMutableArray array];
    
    for (TFHppleElement *e in popularElements) {
        NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
        [dictionaryInArray setObject:[e objectForKey:@"src"] forKey:@"Thumbnail"];
        [dictionaryInArray setObject:[e objectForKey:@"alt"] forKey:@"Title"];
        [popularArray addObject:dictionaryInArray];
    }
    
    [returnDictionary setObject:relationArray forKey:@"Relation"];
    [returnDictionary setObject:popularArray forKey:@"Popular"];
    
    void (^completion)(AmiAmiParserStatus status, NSDictionary *result) = objc_getAssociatedObject(self, &COMPLETIONPOINTER);
    completion(AmiAmiParserStatusSuccess, returnDictionary);
}

+ (void)specProductParser:(UIWebView *)webView {
    NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements = [doc searchWithXPathQuery:@"//div [@class='product_img_area']//a"];
    
    if ([elements count] == 0) {
        [[self webviewLoadsArray] removeAllObjects];
        [webView reload];
        return;
    }
    
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (TFHppleElement *e in elements) {
        [returnArray addObject:[e objectForKey:@"href"]];
    }
    
    void (^completion)(AmiAmiParserStatus status, NSArray *result) = objc_getAssociatedObject(self, &COMPLETIONPOINTER);
    completion(AmiAmiParserStatusSuccess, returnArray);
}

+ (void)rankParser:(UIWebView *)webView {
    NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements = [doc searchWithXPathQuery:@"//div [@class='productranking category2']//img"];
    
    if ([elements count] == 0) {
        [[self webviewLoadsArray] removeAllObjects];
        [webView reload];
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

#pragma mark - UIWebViewDelegate

+ (void)webViewDidStartLoad:(UIWebView *)webView {
    [[self webviewLoadsArray] addObject:[NSObject new]];
}

+ (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[self webviewLoadsArray] removeLastObject];
    
    if ([[self webviewLoadsArray] count] > 0) {
        return;
    } else {
        switch ([self entryType]) {
            case AmiAmiParserEntryTypeRank:
                [self rankParser:webView];
                break;
            case AmiAmiParserEntryTypeSpecProduct:
                [self specProductParser:webView];
                break;
            case AmiAmiParserEntryTypeRelationProduct:
                [self relationProductParser:webView];
                break;
        }
    }
}

+ (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[self webviewLoadsArray] removeLastObject];
    NSLog(@"someone fail : %@", error);
}

#pragma mark - class methods

+(void) parseRankCategory : (int) categoryNumber completion : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion {
    objc_setAssociatedObject(self, &COMPLETIONPOINTER, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setEntryType:AmiAmiParserEntryTypeRank];
    UIWebView *parserWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [parserWebView setDelegate:(id<UIWebViewDelegate>)self];
    [parserWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.amiami.jp/top/page/c/ranking.html"]]];
    objc_setAssociatedObject(self, &PARSEWEBVIEWPOINTER, parserWebView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void) parseSpecProductImagesInURLString : (NSString*) urlString completion : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion {
    objc_setAssociatedObject(self, &COMPLETIONPOINTER, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setEntryType:AmiAmiParserEntryTypeSpecProduct];
    UIWebView *parserWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [parserWebView setDelegate:(id<UIWebViewDelegate>)self];
    [parserWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    objc_setAssociatedObject(self, &PARSEWEBVIEWPOINTER, parserWebView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void) parseRelationProduct : (NSString*) urlString completion : (void (^)(AmiAmiParserStatus status, NSDictionary *result)) completion {
    objc_setAssociatedObject(self, &COMPLETIONPOINTER, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setEntryType:AmiAmiParserEntryTypeRelationProduct];
    UIWebView *parserWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [parserWebView setDelegate:(id<UIWebViewDelegate>)self];
    [parserWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    objc_setAssociatedObject(self, &PARSEWEBVIEWPOINTER, parserWebView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
