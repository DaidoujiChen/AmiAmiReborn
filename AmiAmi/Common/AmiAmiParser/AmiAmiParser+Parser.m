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

+ (void)allProductsParser:(UIWebView *)webView
{
	NSArray *allProductArray = [self allProducts_List:[self TFHppleObject:webView]];
	if (allProductArray) {
		[self objects].arrayCompletion(AmiAmiParserStatusSuccess, allProductArray);
		[SVProgressHUD dismiss];
		[self freeMemory];
	} else {
		[[self objects].parseLock unlock];
	}
}

+ (void)rankProductsParser:(UIWebView *)webView
{
	NSArray *rankProductArray = [self rankProducts_List:[self TFHppleObject:webView]];
	if (rankProductArray) {
		[self objects].arrayCompletion(AmiAmiParserStatusSuccess, rankProductArray);
		[SVProgressHUD dismiss];
		[self freeMemory];
	} else {
		[[self objects].parseLock unlock];
	}
}

+ (void)productInfoParser:(UIWebView *)webView
{
	TFHpple *doc = [self TFHppleObject:webView];
    
	dispatch_queue_t myQueue = dispatch_queue_create("tw.com.daidouji", 0);
	dispatch_group_t group = dispatch_group_create();
    
    @weakify(self);
	dispatch_group_async(group, myQueue, ^{
        @strongify(self);
	    [self productInfo_Images:doc];
	});
    
	dispatch_group_async(group, myQueue, ^{
        @strongify(self);
	    [self productInfo_Informantion:doc];
	});
    
	dispatch_group_async(group, myQueue, ^{
        @strongify(self);
	    [self productInfo_Images:doc];
	});
    
	dispatch_group_async(group, myQueue, ^{
        @strongify(self);
	    [self productInfo_Relation:doc];
	});
    
	dispatch_group_async(group, myQueue, ^{
        @strongify(self);
	    [self productInfo_AlsoBuy:doc];
	});
    
	dispatch_group_async(group, myQueue, ^{
        @strongify(self);
	    [self productInfo_AlsoLike:doc];
	});
    
	dispatch_group_async(group, myQueue, ^{
        @strongify(self);
	    [self productInfo_Popular:doc];
	});
    
	dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
	if (([[self objects].relationProductsArray count] == 0 &&
	     [[self objects].alsoLikeProductArray count] == 0 &&
	     [[self objects].alsoBuyProductArray count] == 0 &&
	     [[self objects].popularProductsArray count] == 0) &&
	    ![self objects].passFlag) {
		[[self objects].parseLock unlock];
		return;
	}
    
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
    
	if ([[self objects].productImagesArray count]) {
        returnDictionary[@"ProductImages"] = [[self objects].productImagesArray mutableCopy];
	}
    
	if ([[self objects].productInfomationArray count]) {
        returnDictionary[@"ProductInformation"] = [[self objects].productInfomationArray mutableCopy];
	}
    
	if ([[self objects].relationProductsArray count]) {
        returnDictionary[@"Relation"] = [[self objects].relationProductsArray mutableCopy];
	}
    
	if ([[self objects].alsoLikeProductArray count]) {
        returnDictionary[@"AlsoLike"] = [[self objects].alsoLikeProductArray mutableCopy];
	}
    
	if ([[self objects].alsoBuyProductArray count]) {
        returnDictionary[@"AlsoBuy"] = [[self objects].alsoBuyProductArray mutableCopy];
	}
    
	if ([[self objects].popularProductsArray count]) {
        returnDictionary[@"Popular"] = [[self objects].popularProductsArray mutableCopy];
	}
    
	[self objects].dictionaryCompletion(AmiAmiParserStatusSuccess, returnDictionary);
	[SVProgressHUD dismiss];
	[self freeMemory];
}

#pragma mark - private

+ (void)freeMemory
{
	[[self objects].webViewTimer invalidate];
	[[self objects].timeoutTimer invalidate];
	[[self objects].parseLock unlock];
	objc_removeAssociatedObjects(self);
}

@end
