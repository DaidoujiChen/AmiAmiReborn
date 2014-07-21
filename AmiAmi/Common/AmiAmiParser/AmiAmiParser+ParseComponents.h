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

+(void) productInfo_Images : (TFHpple*) doc;
+(void) productInfo_Informantion : (TFHpple*) doc;
+(void) productInfo_Relation : (TFHpple*) doc;
+(void) productInfo_AlsoBuy : (TFHpple*) doc;
+(void) productInfo_AlsoLike : (TFHpple*) doc;
+(void) productInfo_Popular : (TFHpple*) doc;

@end
