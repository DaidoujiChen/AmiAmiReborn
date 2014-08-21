//
//  UITableViewCellBase.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/2/7.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "UITableViewCellBase.h"

@implementation UITableViewCellBase

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
		self = arrayOfViews[0];
	}
	return self;
}

@end
