//
//  LightWeightPlist+AccessObject.h
//  LightWeightPlist
//
//  Created by 啟倫 陳 on 2014/3/4.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "LightWeightPlist.h"

#define Cache [LightWeightPlist dataCache]
#define PointerMapping [LightWeightPlist pointerMapping]
#define FileManager [LightWeightPlist fileManager]

@interface LightWeightPlist (AccessObject)
+(NSCache*) dataCache;
+(NSMutableDictionary*) pointerMapping;
+(NSFileManager*) fileManager;
@end
