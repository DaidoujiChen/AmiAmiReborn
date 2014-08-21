//
//  AmiAmiParserObjects.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/5/2.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AmiAmiParserObjects.h"

@implementation AmiAmiParserObjects

- (id)init
{
	self = [super init];
	if (self) {
		self.productImagesArray = [NSMutableArray array];
		self.productInfomationArray = [NSMutableArray array];
		self.relationProductsArray = [NSMutableArray array];
		self.popularProductsArray = [NSMutableArray array];
		self.alsoLikeProductArray = [NSMutableArray array];
		self.alsoBuyProductArray = [NSMutableArray array];
        
		self.parseLock = [NSLock new];
	}
	return self;
}

@end
