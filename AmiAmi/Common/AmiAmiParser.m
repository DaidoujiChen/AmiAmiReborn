//
//  AmiAmiParser.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AmiAmiParser.h"

#import <objc/runtime.h>

#import "AmiAmiParser+AccessObjects.h"

@interface AmiAmiParser (Private)
+(void) rankParser : (UIWebView*) webView;
+(void) biShoJoParser : (UIWebView*) webView;
+(void) productParser : (UIWebView*) webView;

+(void) freeMemory;
+(void) parse : (NSTimer*) timer;

+(NSString*) mergeContentTexts : (TFHppleElement*) content;
+(NSMutableDictionary*) parshThumbnailWithTitle : (TFHppleElement*) element;

+(UIWebView*) makeParseWebViewWithURL : (NSURL*) parseURL;
@end

@implementation AmiAmiParser

#pragma mark - private

+(UIWebView*) makeParseWebViewWithURL : (NSURL*) parseURL {
    UIWebView *parserWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [parserWebView setDelegate:(id<UIWebViewDelegate>)self];
    [parserWebView loadRequest:[NSURLRequest requestWithURL:parseURL]];
    return parserWebView;
}

+ (NSMutableDictionary *)parshThumbnailWithTitle:(TFHppleElement *)element {
    NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
    [dictionaryInArray setObject:[element objectForKey:@"href"] forKey:@"URL"];
    TFHppleElement *child = [element firstChild];
    [dictionaryInArray setObject:[child objectForKey:@"src"] forKey:@"Thumbnail"];
    [dictionaryInArray setObject:[child objectForKey:@"alt"] forKey:@"Title"];
    return dictionaryInArray;
}

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
                [self rankParser:[self parseWebView]];
                break;
            case AmiAmiParserEntryTypeAll:
                [self biShoJoParser:[self parseWebView]];
                break;
            case AmiAmiParserEntryTypeProductInfo:
                [self productParser:[self parseWebView]];
                break;
        }
    }
    
}

+(void) freeMemory {
    [[self webViewTimer] invalidate];
    [[self parseLock] unlock];
    objc_removeAssociatedObjects(self);
}

+(void) biShoJoParser : (UIWebView*) webView {
    NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements = [doc searchWithXPathQuery:@"//table [@class='product_table']//div [@class='product_img']//a"];
    
    if ([elements count] == 0 && ![self passFlag]) {
        [[self parseLock] unlock];
        return;
    }
    
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (TFHppleElement *e in elements) {
        [returnArray addObject:[self parshThumbnailWithTitle:e]];
    }

    [self arrayCompletion](AmiAmiParserStatusSuccess, returnArray);
    [SVProgressHUD dismiss];
    [self freeMemory];
}

+(void) rankParser : (UIWebView*) webView {
    NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    NSDictionary *eachDictionary = [LWPArray(@"AllProducts") objectAtIndex:[[LWPDictionary(@"MISC") objectForKey:@"typeIndex"] intValue]];
    
    NSString *xpathQueryString = [NSString stringWithFormat:@"//div [@id='ranking_page_relate_result']//div [@class='productranking category%@']//li [@class='product_image']//a", [eachDictionary objectForKey:@"category"]];
    
    NSArray *elements = [doc searchWithXPathQuery:xpathQueryString];

    if ([elements count] == 0 && ![self passFlag]) {
        [[self parseLock] unlock];
        return;
    }

    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (TFHppleElement *e in elements) {
        [returnArray addObject:[self parshThumbnailWithTitle:e]];
    }
    
    [self arrayCompletion](AmiAmiParserStatusSuccess, returnArray);
    [SVProgressHUD dismiss];
    [self freeMemory];
}

+(void) productParser : (UIWebView*) webView {
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
                [[self relationProductsArray] addObject:[self parshThumbnailWithTitle:e]];
            }
        }

    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //也會想買
        if ([[self alsoBuyProductArray] count] == 0) {
            NSArray *alsoBuyProductsElementsArray = [doc searchWithXPathQuery:@"//div [@id='logrecom_purchase_result']//a"];
            
            if ([alsoBuyProductsElementsArray count] == 0) return;
            
            for (TFHppleElement *e in alsoBuyProductsElementsArray) {
                [[self alsoBuyProductArray] addObject:[self parshThumbnailWithTitle:e]];
            }
        }
        
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //也會喜歡
        if ([[self alsoLikeProductArray] count] == 0) {
            NSArray *alsoLikeProductsElementsArray = [doc searchWithXPathQuery:@"//div [@id='logrecom_relate_result']//a"];
            
            if ([alsoLikeProductsElementsArray count] == 0) return;
            
            for (TFHppleElement *e in alsoLikeProductsElementsArray) {
                [[self alsoLikeProductArray] addObject:[self parshThumbnailWithTitle:e]];
            }
        }
        
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //熱門商品
        if ([[self popularProductsArray] count] == 0) {
            NSArray *popularProductsElementsArray = [doc searchWithXPathQuery:@"//div [@class='ichioshi']//a"];
            
            if ([popularProductsElementsArray count] == 0) return;
            
            for (TFHppleElement *e in popularProductsElementsArray) {
                [[self popularProductsArray] addObject:[self parshThumbnailWithTitle:e]];
            }
        }
        
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (([[self relationProductsArray] count] == 0 &&
                [[self alsoLikeProductArray] count] == 0 &&
                [[self alsoBuyProductArray] count] == 0 &&
                [[self popularProductsArray] count] == 0) &&
                ![self passFlag]) {
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

            [self dictionaryCompletion](AmiAmiParserStatusSuccess, returnDictionary);
            [SVProgressHUD dismiss];
            [self freeMemory];
        });
    });

}

#pragma mark - UIWebViewDelegate

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

#pragma mark - UIAlertViewDelegate

+(void) alertView : (UIAlertView*) alertView clickedButtonAtIndex : (NSInteger) buttonIndex {
    
    [self setStartDate:[NSDate date]];
    
    switch (buttonIndex) {
        case 0:
        {
            [self setPassAlertView:nil];
            break;
        }
        case 1:
        {
            [self setPassAlertView:nil];
            [self setPassFlag:YES];
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - class methods

+(void) parseAllProducts : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion {
    [self setStartDate:[NSDate date]];
    [self setPassFlag:NO];
    
    NSDictionary *eachDictionary = [LWPArray(@"AllProducts") objectAtIndex:[[LWPDictionary(@"MISC") objectForKey:@"typeIndex"] intValue]];
    
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"讀取最新%@商品...", [eachDictionary objectForKey:@"title"]]
                         maskType:SVProgressHUDMaskTypeBlack];
    [self setArrayCompletion:completion];
    [self setEntryType:AmiAmiParserEntryTypeAll];
    [self setParseWebView:[self makeParseWebViewWithURL:[NSURL URLWithString:[eachDictionary objectForKey:@"allproducts"]]]];
}

+(void) parseRankProducts : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion {
    [self setStartDate:[NSDate date]];
    [self setPassFlag:NO];
    
    NSDictionary *eachDictionary = [LWPArray(@"AllProducts") objectAtIndex:[[LWPDictionary(@"MISC") objectForKey:@"typeIndex"] intValue]];

    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"讀取%@排行商品...", [eachDictionary objectForKey:@"title"]]
                         maskType:SVProgressHUDMaskTypeBlack];
    [self setArrayCompletion:completion];
    [self setEntryType:AmiAmiParserEntryTypeRank];
    [self setParseWebView:[self makeParseWebViewWithURL:[NSURL URLWithString:@"http://www.amiami.jp/top/page/c/ranking.html"]]];
}

+(void) parseProductInfo : (NSString*) urlString completion : (void (^)(AmiAmiParserStatus status, NSDictionary *result)) completion {
    [self setStartDate:[NSDate date]];
    [self setPassFlag:NO];
    [SVProgressHUD showWithStatus:@"讀取商品內容..." maskType:SVProgressHUDMaskTypeBlack];
    [self setDictionaryCompletion:completion];
    [self setEntryType:AmiAmiParserEntryTypeProductInfo];
    [self setParseWebView:[self makeParseWebViewWithURL:[NSURL URLWithString:urlString]]];
}

@end
