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
+(void) setEntryType : (AmiAmiParserEntryType) entryType;
+(AmiAmiParserEntryType) entryType;

+(NSMutableArray*) productImagesArray;
+(NSMutableArray*) relationProductsArray;
+(NSMutableArray*) popularProductsArray;
+(NSMutableArray*) alsoLikeProductArray;
+(NSMutableArray*) alsoBuyProductArray;

+(void) setWebViewTimer : (NSTimer*) webViewTimer;
+(NSTimer*) webViewTimer;

+(NSLock*) parseLock;

+ (void)rankParser:(UIWebView *)webView;
+ (void)biShoJoParser:(UIWebView *)webView;
+ (void)productParser:(UIWebView *)webView;

+(void) freeMemory;
+(void) parse : (NSTimer*) timer;

+(NSString*) mergeContentTexts : (TFHppleElement*) content;
@end

@implementation AmiAmiParser

static const char ENTRYTYPEPOINTER;

static const char PRODUCTIMAGESPOINTER;
static const char PRODUCTINFORMATIONPOINTER;
static const char RELATIONPRODUCTSPOINTER;
static const char POPULARPRODUCTSPOINTER;
static const char ALSOLIKEPRODUCTPOINTER;
static const char ALSOBUYPRODUCTPOINTER;

static const char PARSEWEBVIEWPOINTER;
static const char COMPLETIONPOINTER;

static const char WEBVIEWTIMERPOINTER;
static const char PARSELOCKPOINTER;

#pragma mark - private

#pragma mark access object

+(void) setEntryType : (AmiAmiParserEntryType) entryType {
    objc_setAssociatedObject(self, &ENTRYTYPEPOINTER, [NSNumber numberWithInt:entryType], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(AmiAmiParserEntryType) entryType {
    NSNumber *entry = objc_getAssociatedObject(self, &ENTRYTYPEPOINTER);
    return [entry intValue];
}

+(void) setWebViewTimer : (NSTimer*) webViewTimer {
    objc_setAssociatedObject(self, &WEBVIEWTIMERPOINTER, webViewTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(NSTimer*) webViewTimer {
    return objc_getAssociatedObject(self, &WEBVIEWTIMERPOINTER);
}

+(NSLock*) parseLock {
    if (!objc_getAssociatedObject(self, &PARSELOCKPOINTER)) {
        NSLock *parseLock = [[NSLock alloc] init];
        objc_setAssociatedObject(self, &PARSELOCKPOINTER, parseLock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &PARSELOCKPOINTER);
}

+(NSMutableArray*) productImagesArray {
    if (!objc_getAssociatedObject(self, &PRODUCTIMAGESPOINTER)) {
        objc_setAssociatedObject(self, &PRODUCTIMAGESPOINTER, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &PRODUCTIMAGESPOINTER);
}

+(NSMutableArray*) productInfomationArray {
    if (!objc_getAssociatedObject(self, &PRODUCTINFORMATIONPOINTER)) {
        objc_setAssociatedObject(self, &PRODUCTINFORMATIONPOINTER, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &PRODUCTINFORMATIONPOINTER);
}

+(NSMutableArray*) relationProductsArray {
    if (!objc_getAssociatedObject(self, &RELATIONPRODUCTSPOINTER)) {
        objc_setAssociatedObject(self, &RELATIONPRODUCTSPOINTER, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &RELATIONPRODUCTSPOINTER);
}

+(NSMutableArray*) popularProductsArray {
    if (!objc_getAssociatedObject(self, &POPULARPRODUCTSPOINTER)) {
        objc_setAssociatedObject(self, &POPULARPRODUCTSPOINTER, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &POPULARPRODUCTSPOINTER);
}

+(NSMutableArray*) alsoLikeProductArray {
    if (!objc_getAssociatedObject(self, &ALSOLIKEPRODUCTPOINTER)) {
        objc_setAssociatedObject(self, &ALSOLIKEPRODUCTPOINTER, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &ALSOLIKEPRODUCTPOINTER);
}

+(NSMutableArray*) alsoBuyProductArray {
    if (!objc_getAssociatedObject(self, &ALSOBUYPRODUCTPOINTER)) {
        objc_setAssociatedObject(self, &ALSOBUYPRODUCTPOINTER, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &ALSOBUYPRODUCTPOINTER);
}

#pragma mark function

+(NSString*) mergeContentTexts : (TFHppleElement*) content {
    NSMutableString *returnString = [NSMutableString string];
    
    NSCharacterSet *emptyCharacter = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    if ([content text] != nil &&
        ![[[[content text] componentsSeparatedByCharactersInSet:emptyCharacter] componentsJoinedByString:@""] isEqualToString:@""]) {
        [returnString appendString:[content text]];
    }
    
    for (TFHppleElement *eachChild in [content children]) {
        [returnString appendString:[self mergeContentTexts:eachChild]];
    }
    
    return returnString;
}

+(void) parse : (NSTimer*) timer {
    
    if ([[self parseLock] tryLock]) {
        UIWebView *webView = objc_getAssociatedObject(self, &PARSEWEBVIEWPOINTER);
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

+(void) freeMemory {
    [[self webViewTimer] invalidate];
    [[self parseLock] unlock];
    objc_removeAssociatedObjects(self);
}

+ (void)biShoJoParser:(UIWebView *)webView {
    NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements = [doc searchWithXPathQuery:@"//table [@class='product_table']//div [@class='product_img']//a"];
    
    if ([elements count] == 0) {
        [[self parseLock] unlock];
        return;
    }
    
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (TFHppleElement *e in elements) {
        NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
        
        [dictionaryInArray setObject:[e objectForKey:@"href"] forKey:@"URL"];
        
        TFHppleElement *child = [e firstChild];
        
        [dictionaryInArray setObject:[child objectForKey:@"src"] forKey:@"Thumbnail"];
        [dictionaryInArray setObject:[child objectForKey:@"alt"] forKey:@"Title"];
        
        [returnArray addObject:dictionaryInArray];
    }
    
    void (^completion)(AmiAmiParserStatus status, NSArray *result) = objc_getAssociatedObject(self, &COMPLETIONPOINTER);
    completion(AmiAmiParserStatusSuccess, returnArray);
    [SVProgressHUD dismiss];
    [self freeMemory];
}

+ (void)rankParser:(UIWebView *)webView {
    NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements = [doc searchWithXPathQuery:@"//div [@id='ranking_page_relate_result']//div [@class='productranking category2']//li [@class='product_image']//a"];

    if ([elements count] == 0) {
        [[self parseLock] unlock];
        return;
    }

    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (TFHppleElement *e in elements) {
        
        NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
        
        [dictionaryInArray setObject:[e objectForKey:@"href"] forKey:@"URL"];
        
        TFHppleElement *child = [e firstChild];
        
        [dictionaryInArray setObject:[child objectForKey:@"src"] forKey:@"Thumbnail"];
        [dictionaryInArray setObject:[child objectForKey:@"alt"] forKey:@"Title"];

        [returnArray addObject:dictionaryInArray];
    }
    
    void (^completion)(AmiAmiParserStatus status, NSArray *result) = objc_getAssociatedObject(self, &COMPLETIONPOINTER);
    completion(AmiAmiParserStatusSuccess, returnArray);
    [SVProgressHUD dismiss];
    [self freeMemory];
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
            
            if ([productImagesElementsArray count] == 0) return;
            
            for (TFHppleElement *e in productImagesElementsArray) {
                [[self productImagesArray] addObject:[e objectForKey:@"href"]];
            }
        }
        
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //產品資訊
        if ([[self productInfomationArray] count] == 0) {
            NSArray *productInformationElementsArray = [doc searchWithXPathQuery:@"//div [@id='right_menu']//dl [@class='spec_data']"];
            
            if ([productInformationElementsArray count] == 0) return;
            
            for (TFHppleElement *e in productInformationElementsArray) {
                
                for (int i=0; i<[[e childrenWithTagName:@"dt"] count]; i++) {
                    if ([[(TFHppleElement*)[[e childrenWithTagName:@"dt"] objectAtIndex:i] text] isEqualToString:@"購入制限"] ||
                        [[(TFHppleElement*)[[e childrenWithTagName:@"dt"] objectAtIndex:i] text] isEqualToString:@"備考"]) {
                        continue;
                    } else {
                        NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
                        
                        [dictionaryInArray setObject:[(TFHppleElement*)[[e childrenWithTagName:@"dt"] objectAtIndex:i] text] forKey:@"Title"];
                        [dictionaryInArray setObject:[self mergeContentTexts:[[e childrenWithTagName:@"dd"] objectAtIndex:i]] forKey:@"Content"];
                        
                        [[self productInfomationArray] addObject:dictionaryInArray];
                    }
                }
            }
        }
        
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //相關產品
        if ([[self relationProductsArray] count] == 0) {
            NSArray *relationProductsElementsArray = [doc searchWithXPathQuery:@"//ul [@class='recommend']//table//a"];
            
            if ([relationProductsElementsArray count] == 0) return;
            
            for (TFHppleElement *e in relationProductsElementsArray) {
                NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
                
                [dictionaryInArray setObject:[e objectForKey:@"href"] forKey:@"URL"];
                
                TFHppleElement *child = [e firstChild];
                
                [dictionaryInArray setObject:[child objectForKey:@"src"] forKey:@"Thumbnail"];
                [dictionaryInArray setObject:[child objectForKey:@"alt"] forKey:@"Title"];
                
                [[self relationProductsArray] addObject:dictionaryInArray];
            }
        }

    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //也會想買
        if ([[self alsoBuyProductArray] count] == 0) {
            NSArray *alsoBuyProductsElementsArray = [doc searchWithXPathQuery:@"//div [@id='logrecom_purchase_result']//a"];
            
            if ([alsoBuyProductsElementsArray count] == 0) return;
            
            for (TFHppleElement *e in alsoBuyProductsElementsArray) {
                
                NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];

                [dictionaryInArray setObject:[e objectForKey:@"href"] forKey:@"URL"];

                TFHppleElement *child = [e firstChild];
                
                [dictionaryInArray setObject:[child objectForKey:@"src"] forKey:@"Thumbnail"];
                [dictionaryInArray setObject:[child objectForKey:@"alt"] forKey:@"Title"];
                
                [[self alsoBuyProductArray] addObject:dictionaryInArray];
            }
        }
        
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //也會喜歡
        if ([[self alsoLikeProductArray] count] == 0) {
            NSArray *alsoLikeProductsElementsArray = [doc searchWithXPathQuery:@"//div [@id='logrecom_relate_result']//a"];
            
            if ([alsoLikeProductsElementsArray count] == 0) return;
            
            for (TFHppleElement *e in alsoLikeProductsElementsArray) {
                NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
                
                [dictionaryInArray setObject:[e objectForKey:@"href"] forKey:@"URL"];
                
                TFHppleElement *child = [e firstChild];
                
                [dictionaryInArray setObject:[child objectForKey:@"src"] forKey:@"Thumbnail"];
                [dictionaryInArray setObject:[child objectForKey:@"alt"] forKey:@"Title"];
                
                [[self alsoLikeProductArray] addObject:dictionaryInArray];
            }
        }
        
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //熱門商品
        if ([[self popularProductsArray] count] == 0) {
            NSArray *popularProductsElementsArray = [doc searchWithXPathQuery:@"//div [@class='ichioshi']//a"];
            
            if ([popularProductsElementsArray count] == 0) return;
            
            for (TFHppleElement *e in popularProductsElementsArray) {
                NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
                
                [dictionaryInArray setObject:[e objectForKey:@"href"] forKey:@"URL"];
                
                TFHppleElement *child = [e firstChild];
                
                [dictionaryInArray setObject:[child objectForKey:@"src"] forKey:@"Thumbnail"];
                [dictionaryInArray setObject:[child objectForKey:@"alt"] forKey:@"Title"];
                
                [[self popularProductsArray] addObject:dictionaryInArray];
            }
        }
        
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[self relationProductsArray] count] == 0 &&
                [[self alsoLikeProductArray] count] == 0 &&
                [[self alsoBuyProductArray] count] == 0 &&
                [[self popularProductsArray] count] == 0) {
                [[self parseLock] unlock];
                return;
            }

            NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
            
            if ([[self productImagesArray] count]) {
                [returnDictionary setObject:[[self productImagesArray] mutableCopy] forKey:@"ProductImages"];
            }
            
            if ([[self productInfomationArray] count]) {
                [returnDictionary setObject:[[self productInfomationArray] mutableCopy] forKey:@"ProductInformation"];
            }
            
            if ([[self relationProductsArray] count]) {
                [returnDictionary setObject:[[self relationProductsArray] mutableCopy] forKey:@"Relation"];
            }
            
            if ([[self alsoLikeProductArray] count]) {
                [returnDictionary setObject:[[self alsoLikeProductArray] mutableCopy] forKey:@"AlsoLike"];
            }
            
            if ([[self alsoBuyProductArray] count]) {
                [returnDictionary setObject:[[self alsoBuyProductArray] mutableCopy] forKey:@"AlsoBuy"];
            }
            
            if ([[self popularProductsArray] count]) {
                [returnDictionary setObject:[[self popularProductsArray] mutableCopy] forKey:@"Popular"];
            }
            
            void (^completion)(AmiAmiParserStatus status, NSDictionary *result) = objc_getAssociatedObject(self, &COMPLETIONPOINTER);
            completion(AmiAmiParserStatusSuccess, returnDictionary);
            [SVProgressHUD dismiss];
            [self freeMemory];
        });
    });

}

#pragma mark - UIWebViewDelegate

+ (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if (![self webViewTimer]) {
        [self setWebViewTimer:[NSTimer scheduledTimerWithTimeInterval:1.5f
                                                               target:self
                                                             selector:@selector(parse:)
                                                             userInfo:nil
                                                              repeats:YES]];
    }
    
}

+ (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"someone fail : %@", error);
}

#pragma mark - class methods

+(void) parseAllBiShouJo : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion {
    [SVProgressHUD showWithStatus:@"讀取最新美少女商品..." maskType:SVProgressHUDMaskTypeBlack];
    objc_setAssociatedObject(self, &COMPLETIONPOINTER, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setEntryType:AmiAmiParserEntryTypeAllBiShouJo];
    UIWebView *parserWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [parserWebView setDelegate:(id<UIWebViewDelegate>)self];
    [parserWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.amiami.jp/top/page/c/bishoujo.html"]]];
    objc_setAssociatedObject(self, &PARSEWEBVIEWPOINTER, parserWebView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void) parseBiShoJoRank : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion {
    [SVProgressHUD showWithStatus:@"讀取美少女排行商品..." maskType:SVProgressHUDMaskTypeBlack];
    objc_setAssociatedObject(self, &COMPLETIONPOINTER, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setEntryType:AmiAmiParserEntryTypeRank];
    UIWebView *parserWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [parserWebView setDelegate:(id<UIWebViewDelegate>)self];
    [parserWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.amiami.jp/top/page/c/ranking.html"]]];
    objc_setAssociatedObject(self, &PARSEWEBVIEWPOINTER, parserWebView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void) parseProduct : (NSString*) urlString completion : (void (^)(AmiAmiParserStatus status, NSDictionary *result)) completion {
    [SVProgressHUD showWithStatus:@"讀取商品內容..." maskType:SVProgressHUDMaskTypeBlack];
    objc_setAssociatedObject(self, &COMPLETIONPOINTER, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setEntryType:AmiAmiParserEntryTypeProduct];
    UIWebView *parserWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [parserWebView setDelegate:(id<UIWebViewDelegate>)self];
    [parserWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    objc_setAssociatedObject(self, &PARSEWEBVIEWPOINTER, parserWebView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
