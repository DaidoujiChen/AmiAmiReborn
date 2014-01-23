//
//  AmiAmiParser.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "TFHpple.h"

typedef enum {
    AmiAmiParserStatusFail      =   0,
    AmiAmiParserStatusSuccess
} AmiAmiParserStatus;

typedef enum {
    AmiAmiParserEntryTypeRank       =   0,
    AmiAmiParserEntryTypeSpecProduct
} AmiAmiParserEntryType;

@interface AmiAmiParser : NSObject <UIWebViewDelegate>

+(void) parseRankCategory : (int) categoryNumber completion : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion;
+(void) parseSpecProductImagesInURLString : (NSString*) urlString completion : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion;

@end
