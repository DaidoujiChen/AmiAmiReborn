//
//  AmiAmiParser+AccessObjects.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/2/24.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AmiAmiParser+AccessObjects.h"

@implementation AmiAmiParser (AccessObjects)

+(AmiAmiParserObjects*) objects {
    
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, [AmiAmiParserObjects new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
    
}

@end
