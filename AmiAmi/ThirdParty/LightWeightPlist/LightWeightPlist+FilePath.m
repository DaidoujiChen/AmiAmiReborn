//
//  LightWeightPlist+FilePath.m
//  LightWeightPlist
//
//  Created by 啟倫 陳 on 2014/3/4.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "LightWeightPlist+FilePath.h"

@implementation LightWeightPlist (FilePath)

+(NSString*) resourceFolderPath {
    return [[NSBundle mainBundle] bundlePath];
}

+(NSString*) documentFolderPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+(NSString*) resourceFolderPathWithFilename : (NSString*) filename {
    return [[self resourceFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", filename]];
}

+(NSString*) documentFolderPathWithFilename : (NSString*) filename {
    return [[self documentFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", filename]];
}

@end
