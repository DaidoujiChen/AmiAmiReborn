//
//  AmiAmiParser.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TFHpple.h"
#import "AmiAmiParserObjects.h"

@interface AmiAmiParser : NSObject

+(void) parseRankProducts : (ArrayCompletion) completion;
+(void) parseAllProducts : (ArrayCompletion) completion;
+(void) parseProductInfo : (NSString*) urlString completion : (DictionaryCompletion) completion;

@end
