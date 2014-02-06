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

+(void) setEntryType : (AmiAmiParserEntryType) entryType;
+(AmiAmiParserEntryType) entryType;

+ (void)rankParser:(UIWebView *)webView;
+ (void)biShoJoParser:(UIWebView *)webView;
+ (void)productParser:(UIWebView *)webView;
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

+ (void)biShoJoParser:(UIWebView *)webView {
    NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements = [doc searchWithXPathQuery:@"//table [@class='product_table']//img"];
    
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

+ (void)productParser:(UIWebView *)webView {
    NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    NSArray *elements = [doc searchWithXPathQuery:@"//div [@class='product_img_area']//a"];
    
    if ([elements count] == 0) {
        [[self webviewLoadsArray] removeAllObjects];
        [webView reload];
        return;
    }
    
    //產品圖片
    NSMutableArray *productImagesArray = [NSMutableArray array];
    
    for (TFHppleElement *e in elements) {
        [productImagesArray addObject:[e objectForKey:@"href"]];
    }
    
    NSArray *relationElements = [doc searchWithXPathQuery:@"//div [@class='logrecom_places']//img"];
    
    if ([relationElements count] == 0) {
        [[self webviewLoadsArray] removeAllObjects];
        [webView reload];
        return;
    }
    
    //相關產品
    NSMutableArray *relationArray = [NSMutableArray array];
    
    for (TFHppleElement *e in relationElements) {
        NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
        [dictionaryInArray setObject:[e objectForKey:@"src"] forKey:@"Thumbnail"];
        [dictionaryInArray setObject:[e objectForKey:@"alt"] forKey:@"Title"];
        [relationArray addObject:dictionaryInArray];
    }
    
    NSArray *popularElements = [doc searchWithXPathQuery:@"//div [@class='ichioshi']//img"];
    
    
    //熱門商品
    NSMutableArray *popularArray = [NSMutableArray array];
    
    for (TFHppleElement *e in popularElements) {
        NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
        [dictionaryInArray setObject:[e objectForKey:@"src"] forKey:@"Thumbnail"];
        [dictionaryInArray setObject:[e objectForKey:@"alt"] forKey:@"Title"];
        [popularArray addObject:dictionaryInArray];
    }
    
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
    
    [returnDictionary setObject:productImagesArray forKey:@"ProductImages"];
    [returnDictionary setObject:relationArray forKey:@"Relation"];
    [returnDictionary setObject:popularArray forKey:@"Popular"];
    
    void (^completion)(AmiAmiParserStatus status, NSDictionary *result) = objc_getAssociatedObject(self, &COMPLETIONPOINTER);
    completion(AmiAmiParserStatusSuccess, returnDictionary);
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
            case AmiAmiParserEntryTypeAllBiShouJo:
                [self biShoJoParser:webView];
                break;
            case AmiAmiParserEntryTypeProduct:
                [self productParser:webView];
                break;
        }
    }
}

+ (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[self webviewLoadsArray] removeLastObject];
    NSLog(@"someone fail : %@", error);
}

#pragma mark - class methods

+(void) parseAllBiShouJo : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion {
    objc_setAssociatedObject(self, &COMPLETIONPOINTER, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setEntryType:AmiAmiParserEntryTypeAllBiShouJo];
    UIWebView *parserWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [parserWebView setDelegate:(id<UIWebViewDelegate>)self];
    [parserWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.amiami.jp/top/page/c/bishoujo.html"]]];
    objc_setAssociatedObject(self, &PARSEWEBVIEWPOINTER, parserWebView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void) parseBiShoJoRank : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion {
    objc_setAssociatedObject(self, &COMPLETIONPOINTER, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setEntryType:AmiAmiParserEntryTypeRank];
    UIWebView *parserWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [parserWebView setDelegate:(id<UIWebViewDelegate>)self];
    [parserWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.amiami.jp/top/page/c/ranking.html"]]];
    objc_setAssociatedObject(self, &PARSEWEBVIEWPOINTER, parserWebView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void) parseProduct : (NSString*) urlString completion : (void (^)(AmiAmiParserStatus status, NSDictionary *result)) completion {
    objc_setAssociatedObject(self, &COMPLETIONPOINTER, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setEntryType:AmiAmiParserEntryTypeProduct];
    UIWebView *parserWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [parserWebView setDelegate:(id<UIWebViewDelegate>)self];
    [parserWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    objc_setAssociatedObject(self, &PARSEWEBVIEWPOINTER, parserWebView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
