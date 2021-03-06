//
//  GlobalFunctions.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/23.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalFunctions : NSObject

+ (NSString *)fixProductURL:(NSString *)oriURL;

+ (void)imageEffect:(UIView *)view;
+ (void)textEffect:(UIView *)view;

+ (void)addToHistory:(NSDictionary *)productInfo;
+ (void)addToFavorite;

@end
