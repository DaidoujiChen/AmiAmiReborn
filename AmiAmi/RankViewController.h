//
//  RankViewController.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"
#import "MyPhoto.h"
#import "MyPhotoSource.h"

#import "RankCell.h"

@interface RankViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    NSArray *dataArray;
    UISegmentedControl *typeSegment;
}

@property (nonatomic, strong) NSArray *dataArray;

@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@end
