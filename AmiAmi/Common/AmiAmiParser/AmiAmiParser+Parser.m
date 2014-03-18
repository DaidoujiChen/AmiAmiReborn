//
//  AmiAmiParser+Parser.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/3/19.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AmiAmiParser+Parser.h"

#import "AmiAmiParser+AccessObjects.h"
#import "AmiAmiParser+MiscFunctions.h"

@implementation AmiAmiParser (Parser)

+(void) allProductsParser : (UIWebView*) webView {
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

+(void) rankProductsParser : (UIWebView*) webView {
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

+(void) productInfoParser : (UIWebView*) webView {
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

@end
