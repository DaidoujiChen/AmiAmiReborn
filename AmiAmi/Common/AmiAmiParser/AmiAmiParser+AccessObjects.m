//
//  AmiAmiParser+AccessObjects.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/2/24.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AmiAmiParser+AccessObjects.h"

@implementation AmiAmiParser (AccessObjects)

static const char OBJECTSPOINTER;

+(AmiAmiParserObjects*) objects {
    
    if (!objc_getAssociatedObject(self, &OBJECTSPOINTER)) {
        objc_setAssociatedObject(self, &OBJECTSPOINTER, [AmiAmiParserObjects new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &OBJECTSPOINTER);
    
}

@end
