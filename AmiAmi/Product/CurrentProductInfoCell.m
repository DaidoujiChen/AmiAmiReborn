//
//  CurrentProductInfoCell.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 14/2/7.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "CurrentProductInfoCell.h"

@implementation CurrentProductInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [GlobalFunctions imageEffect:self.currentProductImageView];
        [GlobalFunctions textEffect:self.currentProductTitleTextView];
        [GlobalFunctions textEffect:self.currentProductInformationTextView];
    }
    return self;
}

@end
