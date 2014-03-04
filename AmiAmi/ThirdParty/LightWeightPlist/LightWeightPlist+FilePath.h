//
//  LightWeightPlist+FilePath.h
//  LightWeightPlist
//
//  Created by 啟倫 陳 on 2014/3/4.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "LightWeightPlist.h"

#define ResourceFile(fmt) [LightWeightPlist resourceFolderPathWithFilename:fmt]
#define DocumentFile(fmt) [LightWeightPlist documentFolderPathWithFilename:fmt]

@interface LightWeightPlist (FilePath)
+(NSString*) resourceFolderPathWithFilename : (NSString*) filename;
+(NSString*) documentFolderPathWithFilename : (NSString*) filename;
@end
