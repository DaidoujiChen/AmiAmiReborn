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

    [[[self allProducts_List:[self TFHppleObject:webView]] filter:^BOOL(id value) {
        if (value) return YES;
        return NO;
    }] subscribeNext:^(id x) {
        [self arrayCompletion](AmiAmiParserStatusSuccess, x);
        [SVProgressHUD dismiss];
        [self freeMemory];
    }];
    
    
}

+(void) rankProductsParser : (UIWebView*) webView {

    [[[self rankProducts_List:[self TFHppleObject:webView]] filter:^BOOL(id value) {
        if (value) return YES;
        return NO;
    }] subscribeNext:^(id x) {
        [self arrayCompletion](AmiAmiParserStatusSuccess, x);
        [SVProgressHUD dismiss];
        [self freeMemory];
    }];
    
}

+(void) productInfoParser : (UIWebView*) webView {
    
    TFHpple *doc = [self TFHppleObject:webView];
    
    [[RACSignal merge:@[[self productInfo_Images:doc],
                        [self productInfo_Informantion:doc],
                        [self productInfo_Relation:doc],
                        [self productInfo_AlsoBuy:doc],
                        [self productInfo_AlsoLike:doc],
                        [self productInfo_Popular:doc]]] subscribeCompleted:^{
        
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
    }];
    
}

#pragma mark - private

+(void) freeMemory {
    [[self webViewTimer] invalidate];
    [[self timeoutTimer] invalidate];
    [[self parseLock] unlock];
    objc_removeAssociatedObjects(self);
}

@end
