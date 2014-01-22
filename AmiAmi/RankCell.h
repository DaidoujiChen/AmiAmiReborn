//
//  RankCell.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/22.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FXBlurView.h"

@interface RankCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;

@end
