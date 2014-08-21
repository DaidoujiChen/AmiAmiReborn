//
//  ProductCollectionCell.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/2/5.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "ProductCollectionCell.h"

@implementation ProductCollectionCell

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
		self = arrayOfViews[0];
		[GlobalFunctions imageEffect:self.productImageView];
	}
	return self;
}

- (void)prepareForReuse
{
	self.productImageView.image = nil;
}

@end
