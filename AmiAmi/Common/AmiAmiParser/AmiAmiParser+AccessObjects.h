//
//  AmiAmiParser+AccessObjects.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/2/24.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AmiAmiParser.h"

#import <objc/runtime.h>

@interface AmiAmiParser (AccessObjects)

+(void) setArrayCompletion : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion;
+(void (^)(AmiAmiParserStatus status, NSArray *result)) arrayCompletion;

+(void) setDictionaryCompletion : (void (^)(AmiAmiParserStatus status, NSDictionary *result)) completion;
+(void (^)(AmiAmiParserStatus status, NSDictionary *result)) dictionaryCompletion;

+(void) setParseWebView : (UIWebView*) parseWebView;
+(UIWebView*) parseWebView;

+(void) setEntryType : (AmiAmiParserEntryType) entryType;
+(AmiAmiParserEntryType) entryType;

+(NSMutableArray*) productImagesArray;
+(NSMutableArray*) productInfomationArray;
+(NSMutableArray*) relationProductsArray;
+(NSMutableArray*) popularProductsArray;
+(NSMutableArray*) alsoLikeProductArray;
+(NSMutableArray*) alsoBuyProductArray;

+(void) setWebViewTimer : (DispatchTimer*) webViewTimer;
+(DispatchTimer*) webViewTimer;

+(void) setStartDate : (NSDate*) startDate;
+(NSDate*) startDate;

+(void) setPassFlag : (BOOL) passFlag;
+(BOOL) passFlag;

+(void) setPassAlertView : (UIAlertView*) passAlertView;
+(UIAlertView*) passAlertView;

+(NSLock*) parseLock;
@end
