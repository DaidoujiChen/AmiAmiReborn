//
//  RankViewController.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"

#import "RankCell.h"
#import "SpecProductViewController.h"

@interface RankViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    NSArray *rankInfoArray;
}

@property (nonatomic, strong) NSArray *rankInfoArray;

@property (weak, nonatomic) IBOutlet UITableView *rankTableView;

@end
