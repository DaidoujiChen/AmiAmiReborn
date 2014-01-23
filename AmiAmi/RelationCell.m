//
//  RelationCell.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/23.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "RelationCell.h"

@implementation RelationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        self = [arrayOfViews objectAtIndex:0];
        
        _thumbnailImageView.layer.masksToBounds = NO;
        _thumbnailImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _thumbnailImageView.layer.borderWidth = 3.5f;
        _thumbnailImageView.layer.contentsScale = [UIScreen mainScreen].scale;
        _thumbnailImageView.layer.shadowOpacity = 0.75f;
        _thumbnailImageView.layer.shadowRadius = 5.0f;
        _thumbnailImageView.layer.shadowOffset = CGSizeZero;
        _thumbnailImageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_thumbnailImageView.bounds].CGPath;
        _thumbnailImageView.layer.shouldRasterize = YES;
        
        _titleTextView.layer.shadowColor = [[UIColor whiteColor] CGColor];
        _titleTextView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        _titleTextView.layer.shadowOpacity = 1.0f;
        _titleTextView.layer.shadowRadius = 1.0f;
    }
    return self;
}

@end
