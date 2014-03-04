//
//  LightWeightPlist.h
//  LightWeightPlist
//
//  Created by 啟倫 陳 on 2014/3/4.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LWPArray(fmt) [LightWeightPlist array:fmt]
#define LWPDictionary(fmt) [LightWeightPlist dictionary:fmt]
#define LWPDelete(fmt) [LightWeightPlist delete:fmt]
#define LWPForceWrite() [LightWeightPlist forceWrite]

@interface LightWeightPlist : NSObject <NSCacheDelegate>

#pragma mark - Common

+(void) delete : (NSString*) key;
+(void) forceWrite;

#pragma mark - Array

+(NSMutableArray*) array : (NSString*) key;

#pragma mark - Dictionary

+(NSMutableDictionary*) dictionary : (NSString*) key;

@end
