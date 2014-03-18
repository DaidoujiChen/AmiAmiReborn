//
//  AmiAmiParser.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TFHpple.h"

typedef enum {
    AmiAmiParserStatusFail      =   0,
    AmiAmiParserStatusSuccess
} AmiAmiParserStatus;

typedef enum {
    AmiAmiParserEntryTypeRank       =   0,
    AmiAmiParserEntryTypeAll,
    AmiAmiParserEntryTypeProductInfo
} AmiAmiParserEntryType;

@interface AmiAmiParser : NSObject <UIWebViewDelegate, UIAlertViewDelegate>

+(void) parseRankProducts : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion;
+(void) parseAllProducts : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion;
+(void) parseProductInfo : (NSString*) urlString completion : (void (^)(AmiAmiParserStatus status, NSDictionary *result)) completion;

@end
