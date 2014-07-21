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
#import "AmiAmiParser+ParseComponents.h"

@implementation AmiAmiParser (Parser)

#pragma mark - class method

+(void) allProductsParser : (UIWebView*) webView {
    
    NSArray *allProductArray = [self allProducts_List:[self TFHppleObject:webView]];
    if (allProductArray) {
        self.objects.arrayCompletion(AmiAmiParserStatusSuccess, allProductArray);
        [SVProgressHUD dismiss];
        [self freeMemory];
    } else {
        [self.objects.parseLock unlock];
    }

}

+(void) rankProductsParser : (UIWebView*) webView {
    
    NSArray *rankProductArray = [self rankProducts_List:[self TFHppleObject:webView]];
    if (rankProductArray) {
        self.objects.arrayCompletion(AmiAmiParserStatusSuccess, rankProductArray);
        [SVProgressHUD dismiss];
        [self freeMemory];
    } else {
        [self.objects.parseLock unlock];
    }
    
}

+(void) productInfoParser : (UIWebView*) webView {
    
    TFHpple *doc = [self TFHppleObject:webView];
    
    
    
    [[RACSignal merge:@[[self productInfo_Images:doc],
                        [self productInfo_Informantion:doc],
                        [self productInfo_Relation:doc],
                        [self productInfo_AlsoBuy:doc],
                        [self productInfo_AlsoLike:doc],
                        [self productInfo_Popular:doc]]] subscribeCompleted:^{
        
        if (([self.objects.relationProductsArray count] == 0 &&
             [self.objects.alsoLikeProductArray count] == 0 &&
             [self.objects.alsoBuyProductArray count] == 0 &&
             [self.objects.popularProductsArray count] == 0) &&
            !self.objects.passFlag) {
            [self.objects.parseLock unlock];
            return;
        }
        
        NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
        
        if ([self.objects.productImagesArray count]) {
            [returnDictionary setObject:[self.objects.productImagesArray mutableCopy] forKey:@"ProductImages"];
        }
        
        if ([self.objects.productInfomationArray count]) {
            [returnDictionary setObject:[self.objects.productInfomationArray mutableCopy] forKey:@"ProductInformation"];
        }
        
        if ([self.objects.relationProductsArray count]) {
            [returnDictionary setObject:[self.objects.relationProductsArray mutableCopy] forKey:@"Relation"];
        }
        
        if ([self.objects.alsoLikeProductArray count]) {
            [returnDictionary setObject:[self.objects.alsoLikeProductArray mutableCopy] forKey:@"AlsoLike"];
        }
        
        if ([self.objects.alsoBuyProductArray count]) {
            [returnDictionary setObject:[self.objects.alsoBuyProductArray mutableCopy] forKey:@"AlsoBuy"];
        }
        
        if ([self.objects.popularProductsArray count]) {
            [returnDictionary setObject:[self.objects.popularProductsArray mutableCopy] forKey:@"Popular"];
        }
        
        self.objects.dictionaryCompletion(AmiAmiParserStatusSuccess, returnDictionary);
        [SVProgressHUD dismiss];
        [self freeMemory];
    }];
    
}

#pragma mark - private

+(void) freeMemory {
    [self.objects.webViewTimer invalidate];
    [self.objects.timeoutTimer invalidate];
    [self.objects.parseLock unlock];
    objc_removeAssociatedObjects(self);
}

@end
