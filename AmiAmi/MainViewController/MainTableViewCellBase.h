//
//  MainTableViewCellBase.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/7/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "UITableViewCellBase.h"

@interface MainTableViewCellBase : UITableViewCellBase

@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;

@end
