//
//  AmiAmiParser.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AmiAmiParser.h"

#import <objc/runtime.h>

@interface AmiAmiParser ()
@property (nonatomic, assign) AmiAmiParserEntryType entryType;

@property (nonatomic, strong) NSMutableArray *webviewLoadsArray;
@property (nonatomic, strong) NSMutableArray *productImagesArray;
@property (nonatomic, strong) NSMutableArray *relationProductsArray;
@property (nonatomic, strong) NSMutableArray *popularProductsArray;
@property (nonatomic, strong) NSMutableArray *alsoLikeProductArray;
@end

@interface AmiAmiParser (Private)
+(void) setEntryType : (AmiAmiParserEntryType) entryType;
+(AmiAmiParserEntryType) entryType;

+(NSMutableArray*) webviewLoadsArray;
+(NSMutableArray*) productImagesArray;
+(NSMutableArray*) relationProductsArray;
+(NSMutableArray*) popularProductsArray;
+(NSMutableArray*) alsoLikeProductArray;

+ (void)rankParser:(UIWebView *)webView;
+ (void)biShoJoParser:(UIWebView *)webView;
+ (void)productParser:(UIWebView *)webView;
@end

@implementation AmiAmiParser

@dynamic entryType;

@dynamic webviewLoadsArray;
@dynamic productImagesArray;
@dynamic relationProductsArray;
@dynamic popularProductsArray;

static const char ENTRYTYPEPOINTER;

static const char WEBVIEWLOADSCOUNTPOINTER;
static const char PRODUCTIMAGESPOINTER;
static const char RELATIONPRODUCTSPOINTER;
static const char POPULARPRODUCTSPOINTER;
static const char ALSOLIKEPRODUCTPOINTER;

static const char PARSEWEBVIEWPOINTER;
static const char COMPLETIONPOINTER;

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
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc_setAssociatedObject(self, &WEBVIEWLOADSCOUNTPOINTER, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    return objc_getAssociatedObject(self, &WEBVIEWLOADSCOUNTPOINTER);
}

+(NSMutableArray*) productImagesArray {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc_setAssociatedObject(self, &PRODUCTIMAGESPOINTER, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    return objc_getAssociatedObject(self, &PRODUCTIMAGESPOINTER);
}

+(NSMutableArray*) relationProductsArray {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc_setAssociatedObject(self, &RELATIONPRODUCTSPOINTER, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    return objc_getAssociatedObject(self, &RELATIONPRODUCTSPOINTER);
}

+(NSMutableArray*) popularProductsArray {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc_setAssociatedObject(self, &POPULARPRODUCTSPOINTER, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    return objc_getAssociatedObject(self, &POPULARPRODUCTSPOINTER);
}

+(NSMutableArray*) alsoLikeProductArray {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc_setAssociatedObject(self, &ALSOLIKEPRODUCTPOINTER, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    return objc_getAssociatedObject(self, &ALSOLIKEPRODUCTPOINTER);
}

#pragma mark function

+ (void)biShoJoParser:(UIWebView *)webView {
    NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements = [doc searchWithXPathQuery:@"//table [@class='product_table']//img"];
    
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (TFHppleElement *e in elements) {
        NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
        [dictionaryInArray setObject:[e objectForKey:@"src"] forKey:@"Thumbnail"];
        [dictionaryInArray setObject:[e objectForKey:@"alt"] forKey:@"Title"];
        [returnArray addObject:dictionaryInArray];
    }
    
    void (^completion)(AmiAmiParserStatus status, NSArray *result) = objc_getAssociatedObject(self, &COMPLETIONPOINTER);
    completion(AmiAmiParserStatusSuccess, returnArray);
    [SVProgressHUD dismiss];
}

+ (void)rankParser:(UIWebView *)webView {
    NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements = [doc searchWithXPathQuery:@"//div [@class='productranking category2']//img"];
    
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (TFHppleElement *e in elements) {
        NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
        [dictionaryInArray setObject:[e objectForKey:@"src"] forKey:@"Thumbnail"];
        [dictionaryInArray setObject:[e objectForKey:@"alt"] forKey:@"Title"];
        [returnArray addObject:dictionaryInArray];
    }
    
    void (^completion)(AmiAmiParserStatus status, NSArray *result) = objc_getAssociatedObject(self, &COMPLETIONPOINTER);
    completion(AmiAmiParserStatusSuccess, returnArray);
    [SVProgressHUD dismiss];
}

+ (void)productParser:(UIWebView *)webView {
    NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    dispatch_group_t group = dispatch_group_create();
 
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        //產品圖片
        if ([self.productImagesArray count] == 0) {
            NSArray *productImagesElementsArray = [doc searchWithXPathQuery:@"//div [@class='product_img_area']//a"];
            
            if ([productImagesElementsArray count] == 0) return;
            
            for (TFHppleElement *e in productImagesElementsArray) {
                [self.productImagesArray addObject:[e objectForKey:@"href"]];
            }
        }
        
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //相關產品
        if ([self.relationProductsArray count] == 0) {
            NSArray *relationProductsElementsArray = [doc searchWithXPathQuery:@"//ul [@class='recommend']//table//img"];
            
            if ([relationProductsElementsArray count] == 0) return;
            
            for (TFHppleElement *e in relationProductsElementsArray) {
                NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
                [dictionaryInArray setObject:[e objectForKey:@"src"] forKey:@"Thumbnail"];
                [dictionaryInArray setObject:[e objectForKey:@"alt"] forKey:@"Title"];
                [self.relationProductsArray addObject:dictionaryInArray];
            }
        }

    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //也會喜歡
        if ([self.alsoLikeProductArray count] == 0) {
            NSArray *alsoLikeProductsElementsArray = [doc searchWithXPathQuery:@"//div [@id='logrecom_purchase_result']//img"];
            
            if ([alsoLikeProductsElementsArray count] == 0) return;
            
            for (TFHppleElement *e in alsoLikeProductsElementsArray) {
                NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
                [dictionaryInArray setObject:[e objectForKey:@"src"] forKey:@"Thumbnail"];
                [dictionaryInArray setObject:[e objectForKey:@"alt"] forKey:@"Title"];
                [self.alsoLikeProductArray addObject:dictionaryInArray];
            }
        }
        
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //熱門商品
        if ([self.popularProductsArray count] == 0) {
            NSArray *popularProductsElementsArray = [doc searchWithXPathQuery:@"//div [@class='ichioshi']//img"];
            
            if ([popularProductsElementsArray count] == 0) return;
            
            for (TFHppleElement *e in popularProductsElementsArray) {
                NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
                [dictionaryInArray setObject:[e objectForKey:@"src"] forKey:@"Thumbnail"];
                [dictionaryInArray setObject:[e objectForKey:@"alt"] forKey:@"Title"];
                [self.popularProductsArray addObject:dictionaryInArray];
            }
        }
        
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
            
            [returnDictionary setObject:[self.productImagesArray mutableCopy] forKey:@"ProductImages"];
            [returnDictionary setObject:[self.relationProductsArray mutableCopy] forKey:@"Relation"];
            [returnDictionary setObject:[self.alsoLikeProductArray mutableCopy] forKey:@"AlsoLike"];
            [returnDictionary setObject:[self.popularProductsArray mutableCopy] forKey:@"Popular"];
            
            void (^completion)(AmiAmiParserStatus status, NSDictionary *result) = objc_getAssociatedObject(self, &COMPLETIONPOINTER);
            completion(AmiAmiParserStatusSuccess, returnDictionary);
            [SVProgressHUD dismiss];
            
            [self.productImagesArray removeAllObjects];
            [self.relationProductsArray removeAllObjects];
            [self.alsoLikeProductArray removeAllObjects];
            [self.popularProductsArray removeAllObjects];
            
        });
    });

}

#pragma mark - UIWebViewDelegate

+ (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.webviewLoadsArray addObject:[NSObject new]];
}

+ (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self.webviewLoadsArray removeLastObject];
    
    NSString *readyStateString = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    if ([self.webviewLoadsArray count] > 0) {
        return;
    } else if ([readyStateString isEqualToString:@"interactive"]) {
        [webView performSelector:@selector(reload) withObject:nil afterDelay:1.0f];
        return;
    } else {
        switch (self.entryType) {
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
    [self.webviewLoadsArray removeLastObject];
    NSLog(@"someone fail : %@", error);
}

#pragma mark - class methods

+(void) parseAllBiShouJo : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion {
    [SVProgressHUD showWithStatus:@"讀取最新美少女商品..." maskType:SVProgressHUDMaskTypeBlack];
    objc_setAssociatedObject(self, &COMPLETIONPOINTER, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.entryType = AmiAmiParserEntryTypeAllBiShouJo;
    UIWebView *parserWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [parserWebView setDelegate:(id<UIWebViewDelegate>)self];
    [parserWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.amiami.jp/top/page/c/bishoujo.html"]]];
    objc_setAssociatedObject(self, &PARSEWEBVIEWPOINTER, parserWebView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void) parseBiShoJoRank : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion {
    [SVProgressHUD showWithStatus:@"讀取美少女排行商品..." maskType:SVProgressHUDMaskTypeBlack];
    objc_setAssociatedObject(self, &COMPLETIONPOINTER, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.entryType = AmiAmiParserEntryTypeRank;
    UIWebView *parserWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [parserWebView setDelegate:(id<UIWebViewDelegate>)self];
    [parserWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.amiami.jp/top/page/c/ranking.html"]]];
    objc_setAssociatedObject(self, &PARSEWEBVIEWPOINTER, parserWebView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void) parseProduct : (NSString*) urlString completion : (void (^)(AmiAmiParserStatus status, NSDictionary *result)) completion {
    [SVProgressHUD showWithStatus:@"讀取商品內容..." maskType:SVProgressHUDMaskTypeBlack];
    objc_setAssociatedObject(self, &COMPLETIONPOINTER, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.entryType = AmiAmiParserEntryTypeProduct;
    UIWebView *parserWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [parserWebView setDelegate:(id<UIWebViewDelegate>)self];
    [parserWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    objc_setAssociatedObject(self, &PARSEWEBVIEWPOINTER, parserWebView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
