//
//  AmiAmiParser+ParseComponents.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/4/7.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AmiAmiParser+ParseComponents.h"

#import "AmiAmiParser+AccessObjects.h"

@implementation AmiAmiParser (ParseComponents)

#pragma mark - class method

+(TFHpple*) TFHppleObject : (UIWebView*) webView {
    NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    return doc;
}

+(RACSignal*) allProducts_List : (TFHpple*) doc {
    
    NSArray *elements = [doc searchWithXPathQuery:@"//table [@class='product_table']//div [@class='product_img']//a"];
    
    if ([elements count] == 0 && ![self passFlag]) {
        [[self parseLock] unlock];
        return [RACSignal return:nil];
    }
    
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (TFHppleElement *e in elements) {
        [returnArray addObject:[self parshThumbnailWithTitle:e]];
    }
    
    return [RACSignal return:returnArray];
    
}

+(RACSignal*) rankProducts_List : (TFHpple*) doc {
    
    NSDictionary *eachDictionary = [LWPArray(@"AllProducts") objectAtIndex:[[LWPDictionary(@"MISC") objectForKey:@"typeIndex"] intValue]];
    
    NSString *xpathQueryString = [NSString stringWithFormat:@"//div [@id='ranking_page_relate_result']//div [@class='productranking category%@']//li [@class='product_image']//a", [eachDictionary objectForKey:@"category"]];
    
    NSArray *elements = [doc searchWithXPathQuery:xpathQueryString];
    
    if ([elements count] == 0 && ![self passFlag]) {
        [[self parseLock] unlock];
        return [RACSignal return:nil];
    }
    
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (TFHppleElement *e in elements) {
        [returnArray addObject:[self parshThumbnailWithTitle:e]];
    }
    
    return [RACSignal return:returnArray];
    
}

+(RACSignal*) productInfo_Images : (TFHpple*) doc {

    [self semaphoreBlock:^{
        //產品圖片
        if ([[self productImagesArray] count] == 0) {
            NSArray *productImagesElementsArray = [doc searchWithXPathQuery:@"//div [@class='product_img_area']//a"];
            
            if ([productImagesElementsArray count] == 0) return;
            
            for (TFHppleElement *e in productImagesElementsArray) {
                [[self productImagesArray] addObject:[e objectForKey:@"href"]];
            }
        }
    }];
    
    return [RACSignal empty];
    
}

+(RACSignal*) productInfo_Informantion : (TFHpple*) doc {
    
    [self semaphoreBlock:^{
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
    }];
    
    return [RACSignal empty];
    
}


+(RACSignal*) productInfo_Relation : (TFHpple*) doc {
    
    [self semaphoreBlock:^{
        //相關產品
        if ([[self relationProductsArray] count] == 0) {
            NSArray *relationProductsElementsArray = [doc searchWithXPathQuery:@"//ul [@class='recommend']//table//a"];
            
            if ([relationProductsElementsArray count] == 0) {
                return;
            }
            
            for (TFHppleElement *e in relationProductsElementsArray) {
                [[self relationProductsArray] addObject:[self parshThumbnailWithTitle:e]];
            }
        }
    }];
    
    return [RACSignal empty];
    
}

+(RACSignal*) productInfo_AlsoBuy : (TFHpple*) doc {

    [self semaphoreBlock:^{
        //也會想買
        if ([[self alsoBuyProductArray] count] == 0) {
            NSArray *alsoBuyProductsElementsArray = [doc searchWithXPathQuery:@"//div [@id='logrecom_purchase_result']//a"];
            
            if ([alsoBuyProductsElementsArray count] == 0) return;
            
            for (TFHppleElement *e in alsoBuyProductsElementsArray) {
                [[self alsoBuyProductArray] addObject:[self parshThumbnailWithTitle:e]];
            }
        }

    }];
    
    return [RACSignal empty];
    
}

+(RACSignal*) productInfo_AlsoLike : (TFHpple*) doc {
    
    [self semaphoreBlock:^{
        //也會喜歡
        if ([[self alsoLikeProductArray] count] == 0) {
            NSArray *alsoLikeProductsElementsArray = [doc searchWithXPathQuery:@"//div [@id='logrecom_relate_result']//a"];
            
            if ([alsoLikeProductsElementsArray count] == 0) return;
            
            for (TFHppleElement *e in alsoLikeProductsElementsArray) {
                [[self alsoLikeProductArray] addObject:[self parshThumbnailWithTitle:e]];
            }
        }
    }];
    
    return [RACSignal empty];
    
}

+(RACSignal*) productInfo_Popular : (TFHpple*) doc {

    [self semaphoreBlock:^{
        //熱門商品
        if ([[self popularProductsArray] count] == 0) {
            NSArray *popularProductsElementsArray = [doc searchWithXPathQuery:@"//div [@class='ichioshi']//a"];
            
            if ([popularProductsElementsArray count] == 0) return;
            
            for (TFHppleElement *e in popularProductsElementsArray) {
                [[self popularProductsArray] addObject:[self parshThumbnailWithTitle:e]];
            }
        }
    }];
    
    return [RACSignal empty];
}

#pragma mark - private

+(NSMutableDictionary*) parshThumbnailWithTitle : (TFHppleElement*) element {
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

+(void) semaphoreBlock : (void(^)(void)) block {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        block();
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

@end