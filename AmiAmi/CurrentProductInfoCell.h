//
//  CurrentProductInfoCell.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 14/2/7.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UITableViewCellBase.h"

@interface CurrentProductInfoCell : UITableViewCellBase

@property (weak, nonatomic) IBOutlet UIImageView *currentProductImageView;
@property (weak, nonatomic) IBOutlet UITextView *currentProductTitleTextView;
@property (weak, nonatomic) IBOutlet UITextView *currentProductInformationTextView;

@end
