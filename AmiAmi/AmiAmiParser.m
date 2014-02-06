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

+(NSMutableArray*) productImagesArray;
+(NSMutableArray*) relationProductsArray;
+(NSMutableArray*) popularProductsArray;

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

static const char PRODUCTIMAGESPOINTER;
static const char RELATIONPRODUCTSPOINTER;
static const char POPULARPRODUCTSPOINTER;

#pragma mark - private

#pragma mark access object

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

+(NSMutableArray*) productImagesArray {
    NSMutableArray *array = objc_getAssociatedObject(self, &PRODUCTIMAGESPOINTER);
    
    if (array == nil) {
        array = [NSMutableArray array];
        objc_setAssociatedObject(self, &PRODUCTIMAGESPOINTER, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return array;
}

+(NSMutableArray*) relationProductsArray {
    NSMutableArray *array = objc_getAssociatedObject(self, &RELATIONPRODUCTSPOINTER);
    
    if (array == nil) {
        array = [NSMutableArray array];
        objc_setAssociatedObject(self, &RELATIONPRODUCTSPOINTER, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return array;
}

+(NSMutableArray*) popularProductsArray {
    NSMutableArray *array = objc_getAssociatedObject(self, &POPULARPRODUCTSPOINTER);
    
    if (array == nil) {
        array = [NSMutableArray array];
        objc_setAssociatedObject(self, &POPULARPRODUCTSPOINTER, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return array;
}

#pragma mark function

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
    
    dispatch_group_t group = dispatch_group_create();
 
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        //產品圖片
        if ([[self productImagesArray] count] == 0) {
            NSArray *productImagesElementsArray = [doc searchWithXPathQuery:@"//div [@class='product_img_area']//a"];
            
            if ([productImagesElementsArray count] == 0) {
                [[self webviewLoadsArray] removeAllObjects];
                [webView reload];
                return;
            }
            
            for (TFHppleElement *e in productImagesElementsArray) {
                [[self productImagesArray] addObject:[e objectForKey:@"href"]];
            }
        }
        
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //相關產品
        if ([[self relationProductsArray] count] == 0) {
            NSArray *relationProductsElementsArray = [doc searchWithXPathQuery:@"//div [@class='logrecom_places']//img"];
            
            if ([relationProductsElementsArray count] == 0) {
                [[self webviewLoadsArray] removeAllObjects];
                [webView reload];
                return;
            }
            
            for (TFHppleElement *e in relationProductsElementsArray) {
                NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
                [dictionaryInArray setObject:[e objectForKey:@"src"] forKey:@"Thumbnail"];
                [dictionaryInArray setObject:[e objectForKey:@"alt"] forKey:@"Title"];
                [[self relationProductsArray] addObject:dictionaryInArray];
            }
        }
        
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //熱門商品
        if ([[self popularProductsArray] count] == 0) {
            NSArray *popularProductsElementsArray = [doc searchWithXPathQuery:@"//div [@class='ichioshi']//img"];
            
            if ([popularProductsElementsArray count] == 0) {
                [[self webviewLoadsArray] removeAllObjects];
                [webView reload];
                return;
            }
            
            for (TFHppleElement *e in popularProductsElementsArray) {
                NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
                [dictionaryInArray setObject:[e objectForKey:@"src"] forKey:@"Thumbnail"];
                [dictionaryInArray setObject:[e objectForKey:@"alt"] forKey:@"Title"];
                [[self popularProductsArray] addObject:dictionaryInArray];
            }
        }
        
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[self productImagesArray] count] != 0 &&
                [[self relationProductsArray] count] != 0 &&
                [[self popularProductsArray] count] != 0) {
                
                NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
                
                [returnDictionary setObject:[self productImagesArray] forKey:@"ProductImages"];
                [returnDictionary setObject:[self relationProductsArray] forKey:@"Relation"];
                [returnDictionary setObject:[self popularProductsArray] forKey:@"Popular"];
                
                void (^completion)(AmiAmiParserStatus status, NSDictionary *result) = objc_getAssociatedObject(self, &COMPLETIONPOINTER);
                completion(AmiAmiParserStatusSuccess, returnDictionary);

            }
        });
    });

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
