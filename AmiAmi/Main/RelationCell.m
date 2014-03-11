//
//  RelationCell.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/23.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "RelationCell.h"

@implementation RelationCell

-(id) initWithStyle : (UITableViewCellStyle) style reuseIdentifier : (NSString*) reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [GlobalFunctions imageEffect:self.thumbnailImageView];
        [GlobalFunctions textEffect:self.titleTextView];
    }
    return self;
}

-(void) prepareForReuse {
    self.thumbnailImageView.image = nil;
}

@end
