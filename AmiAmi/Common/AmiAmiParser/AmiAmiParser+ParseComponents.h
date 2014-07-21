//
//  AmiAmiParser+ParseComponents.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/4/7.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AmiAmiParser.h"

@interface AmiAmiParser (ParseComponents)

+(TFHpple*) TFHppleObject : (UIWebView*) webView;

+(NSArray*) allProducts_List : (TFHpple*) doc;
+(NSArray*) rankProducts_List : (TFHpple*) doc;

+(RACSignal*) productInfo_Images : (TFHpple*) doc;
+(RACSignal*) productInfo_Informantion : (TFHpple*) doc;
+(RACSignal*) productInfo_Relation : (TFHpple*) doc;
+(RACSignal*) productInfo_AlsoBuy : (TFHpple*) doc;
+(RACSignal*) productInfo_AlsoLike : (TFHpple*) doc;
+(RACSignal*) productInfo_Popular : (TFHpple*) doc;

@end
