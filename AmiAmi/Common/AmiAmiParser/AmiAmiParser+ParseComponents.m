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

+(NSArray*) allProducts_List : (TFHpple*) doc {
    
    NSArray *elements = [doc searchWithXPathQuery:@"//table [@class='product_table']//div [@class='product_img']//a"];
    
    if ([elements count] == 0 && !self.objects.passFlag) {
        return nil;
    }
    
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (TFHppleElement *e in elements) {
        [returnArray addObject:[self parshThumbnailWithTitle:e]];
    }
    
    return returnArray;
    
}

+(NSArray*) rankProducts_List : (TFHpple*) doc {
    
    NSDictionary *eachDictionary = AllProductsArray[[MiscDictionary[@"typeIndex"] integerValue]];
    
    NSString *xpathQueryString = [NSString stringWithFormat:@"//div [@id='ranking_page_relate_result']//div [@class='productranking category%@']//li [@class='product_image']//a", eachDictionary[@"category"]];
    
    NSArray *elements = [doc searchWithXPathQuery:xpathQueryString];
    
    if ([elements count] == 0 && !self.objects.passFlag) {
        return nil;
    }
    
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (TFHppleElement *e in elements) {
        [returnArray addObject:[self parshThumbnailWithTitle:e]];
    }
    
    return returnArray;
    
}

+(void) productInfo_Images : (TFHpple*) doc {

    //產品圖片
    if ([self.objects.productImagesArray count] == 0) {
        NSArray *productImagesElementsArray = [doc searchWithXPathQuery:@"//div [@class='product_img_area']//a"];
        
        if ([productImagesElementsArray count] == 0) return;
        
        for (TFHppleElement *e in productImagesElementsArray) {
            [self.objects.productImagesArray addObject:e[@"href"]];
        }
    }
    
}

+(void) productInfo_Informantion : (TFHpple*) doc {
    
    //產品資訊
    if ([self.objects.productInfomationArray count] == 0) {
        NSArray *productInformationElementsArray = [doc searchWithXPathQuery:@"//div [@id='right_menu']//dl [@class='spec_data']"];
        
        if ([productInformationElementsArray count] == 0) return;
        
        for (TFHppleElement *e in productInformationElementsArray) {
            
            for (int i=0; i<[[e childrenWithTagName:@"dt"] count]; i++) {
                if ([[(TFHppleElement*)[e childrenWithTagName:@"dt"][i] text] isEqualToString:@"購入制限"] ||
                    [[(TFHppleElement*)[e childrenWithTagName:@"dt"][i] text] isEqualToString:@"備考"]) {
                    continue;
                } else {
                    NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
                    
                    [dictionaryInArray setObject:[(TFHppleElement*)[e childrenWithTagName:@"dt"][i] text] forKey:@"Title"];
                    [dictionaryInArray setObject:[self mergeContentTexts:[e childrenWithTagName:@"dd"][i]] forKey:@"Content"];
                    
                    [self.objects.productInfomationArray addObject:dictionaryInArray];
                }
            }
        }
    }

    
}


+(void) productInfo_Relation : (TFHpple*) doc {
    
    //相關產品
    if ([self.objects.relationProductsArray count] == 0) {
        NSArray *relationProductsElementsArray = [doc searchWithXPathQuery:@"//ul [@class='recommend']//table//a"];
        
        if ([relationProductsElementsArray count] == 0) {
            return;
        }
        
        for (TFHppleElement *e in relationProductsElementsArray) {
            [self.objects.relationProductsArray addObject:[self parshThumbnailWithTitle:e]];
        }
    }
    
}

+(void) productInfo_AlsoBuy : (TFHpple*) doc {

    //也會想買
    if ([self.objects.alsoBuyProductArray count] == 0) {
        NSArray *alsoBuyProductsElementsArray = [doc searchWithXPathQuery:@"//div [@id='logrecom_purchase_result']//a"];
        
        if ([alsoBuyProductsElementsArray count] == 0) return;
        
        for (TFHppleElement *e in alsoBuyProductsElementsArray) {
            [self.objects.alsoBuyProductArray addObject:[self parshThumbnailWithTitle:e]];
        }
    }
    
}

+(void) productInfo_AlsoLike : (TFHpple*) doc {
    
    //也會喜歡
    if ([self.objects.alsoLikeProductArray count] == 0) {
        NSArray *alsoLikeProductsElementsArray = [doc searchWithXPathQuery:@"//div [@id='logrecom_relate_result']//a"];
        
        if ([alsoLikeProductsElementsArray count] == 0) return;
        
        for (TFHppleElement *e in alsoLikeProductsElementsArray) {
            [self.objects.alsoLikeProductArray addObject:[self parshThumbnailWithTitle:e]];
        }
    }
    
}

+(void) productInfo_Popular : (TFHpple*) doc {

    //熱門商品
    if ([self.objects.popularProductsArray count] == 0) {
        NSArray *popularProductsElementsArray = [doc searchWithXPathQuery:@"//div [@class='ichioshi']//a"];
        
        if ([popularProductsElementsArray count] == 0) return;
        
        for (TFHppleElement *e in popularProductsElementsArray) {
            [self.objects.popularProductsArray addObject:[self parshThumbnailWithTitle:e]];
        }
    }
    
}

#pragma mark - private

+(NSMutableDictionary*) parshThumbnailWithTitle : (TFHppleElement*) element {
    NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
    [dictionaryInArray setObject:element[@"href"] forKey:@"URL"];
    TFHppleElement *child = [element firstChild];
    [dictionaryInArray setObject:child[@"src"] forKey:@"Thumbnail"];
    [dictionaryInArray setObject:child[@"alt"] forKey:@"Title"];
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

@end
