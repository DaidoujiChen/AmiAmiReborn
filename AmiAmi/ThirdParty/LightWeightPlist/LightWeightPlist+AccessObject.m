//
//  LightWeightPlist+AccessObject.m
//  LightWeightPlist
//
//  Created by 啟倫 陳 on 2014/3/4.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "LightWeightPlist+AccessObject.h"

#import <objc/runtime.h>

@implementation LightWeightPlist (AccessObject)

static const char DATACACHEPOINTER;
static const char POINTERMAPPINGPOINTER;
static const char FILEMANAGERPOINTER;

+(NSCache*) dataCache {
    if (!objc_getAssociatedObject(self, &DATACACHEPOINTER)) {
        NSCache *dataCache = [NSCache new];
        [dataCache setDelegate:(id<NSCacheDelegate>)self];
        objc_setAssociatedObject(self, &DATACACHEPOINTER, dataCache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &DATACACHEPOINTER);
}

+(NSMutableDictionary*) pointerMapping {
    if (!objc_getAssociatedObject(self, &POINTERMAPPINGPOINTER)) {
        objc_setAssociatedObject(self, &POINTERMAPPINGPOINTER, [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &POINTERMAPPINGPOINTER);
}

+(NSFileManager*) fileManager {
    if (!objc_getAssociatedObject(self, &FILEMANAGERPOINTER)) {
        objc_setAssociatedObject(self, &FILEMANAGERPOINTER, [NSFileManager defaultManager], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &FILEMANAGERPOINTER);
}

@end
