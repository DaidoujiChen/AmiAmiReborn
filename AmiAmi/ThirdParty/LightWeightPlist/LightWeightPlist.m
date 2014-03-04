//
//  LightWeightPlist.m
//  LightWeightPlist
//
//  Created by 啟倫 陳 on 2014/3/4.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "LightWeightPlist.h"
#import "LightWeightPlist+AccessObject.h"
#import "LightWeightPlist+FilePath.h"

#import <objc/runtime.h>

@interface LightWeightPlist (Private)

+(BOOL) setObjectToCache : (id) object withKey : (NSString*) key;
+(id) objectFromCache : (NSString*) key;

+(instancetype) getPlistFile : (NSString*) filename isArray : (BOOL) isArray inResource : (BOOL) inResource;
+(NSMutableArray*) arrayInDocument : (NSString*) key;
+(NSMutableArray*) arrayInResource : (NSString*) key;
+(NSMutableDictionary*) dictionaryInDocument : (NSString*) key;
+(NSMutableDictionary*) dictionaryInResource : (NSString*) key;
@end

@implementation LightWeightPlist

#pragma mark - NSCacheDelegate

+(void) cache : (NSCache*) cache willEvictObject : (id) obj {
    
    id associatedObject = objc_getAssociatedObject(self, (__bridge const void *)obj);
    
    NSString *filename = [PointerMapping objectForKey:[NSString stringWithFormat:@"%p", obj]];
    
    NSString *path = DocumentFile(filename);
    
    if ([associatedObject isKindOfClass:[NSDictionary class]]) {
        [(NSDictionary*)associatedObject writeToFile:path atomically:YES];
    } else if ([associatedObject isKindOfClass:[NSArray class]]) {
        [(NSArray*)associatedObject writeToFile:path atomically:YES];
    }
    
    [PointerMapping removeObjectForKey:[NSString stringWithFormat:@"%p", obj]];
    
}

#pragma mark - private

#pragma mark cache handle

+(BOOL) setObjectToCache : (id) object withKey : (NSString*) key {
    
    if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]]) {
        NSObject *emptyObject = [NSObject new];
        [Cache setObject:emptyObject
                  forKey:key];
        objc_setAssociatedObject(self, (__bridge const void *)[Cache objectForKey:key], object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [PointerMapping setObject:key forKey:[NSString stringWithFormat:@"%p", [Cache objectForKey:key]]];
        return YES;
    } else {
        return NO;
    }
    
}

+(id) objectFromCache : (NSString*) key {
    return objc_getAssociatedObject(self, (__bridge const void *)[Cache objectForKey:key]);
}

#pragma mark read file from disk

+(instancetype) getPlistFile : (NSString*) filename isArray : (BOOL) isArray inResource : (BOOL) inResource {
    NSString *path;
    
    if (inResource) {
        path = ResourceFile(filename);
    } else {
        path = DocumentFile(filename);
    }
    
    if (![FileManager fileExistsAtPath:path]) {
        return nil;
    } else {
        if (isArray) {
            return [NSMutableArray arrayWithContentsOfFile:path];
        } else {
            return [NSMutableDictionary dictionaryWithContentsOfFile:path];
        }
    }
}

+(NSMutableArray*) arrayInDocument : (NSString*) key {
    return (NSMutableArray*)[self getPlistFile:key isArray:YES inResource:NO];
}

+(NSMutableArray*) arrayInResource : (NSString*) key {
    return (NSMutableArray*)[self getPlistFile:key isArray:YES inResource:YES];
}

+(NSMutableDictionary*) dictionaryInDocument : (NSString*) key {
    return (NSMutableDictionary*)[self getPlistFile:key isArray:NO inResource:NO];
}

+(NSMutableDictionary*) dictionaryInResource : (NSString*) key {
    return (NSMutableDictionary*)[self getPlistFile:key isArray:NO inResource:YES];
}

#pragma mark - general function
#pragma mark common

+(void) delete : (NSString*) key {
    
    NSString *path = DocumentFile(key);
    
    [FileManager removeItemAtPath:path error:NULL];
    
    if ([Cache objectForKey:key]) {
        [PointerMapping removeObjectForKey:[NSString stringWithFormat:@"%p", [Cache objectForKey:key]]];
        [Cache removeObjectForKey:key];
    }
    
}

+(void) forceWrite {
    [Cache removeAllObjects];
}

#pragma mark array

+(NSMutableArray*) array : (NSString*) key {
    
    if ([self objectFromCache:key]) {
    } else if ([self arrayInDocument:key]) {
        [self setObjectToCache:[self arrayInDocument:key] withKey:key];
    } else if ([self arrayInResource:key]) {
        [self setObjectToCache:[self arrayInResource:key] withKey:key];
    } else {
        [self setObjectToCache:[NSMutableArray array] withKey:key];
    }
    return [self objectFromCache:key];
    
}

#pragma mark dictionary

+(NSMutableDictionary*) dictionary : (NSString*) key {
    
    if ([self objectFromCache:key]) {
    } else if ([self dictionaryInDocument:key]) {
        [self setObjectToCache:[self dictionaryInDocument:key] withKey:key];
    } else if ([self dictionaryInResource:key]) {
        [self setObjectToCache:[self dictionaryInResource:key] withKey:key];
    } else {
        [self setObjectToCache:[NSMutableDictionary dictionary] withKey:key];
    }
    return [self objectFromCache:key];
    
}

@end
