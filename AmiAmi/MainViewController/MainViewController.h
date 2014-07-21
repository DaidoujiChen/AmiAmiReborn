//
//  MainViewController.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProductViewController.h"
#import "SelectProductTypeViewController.h"
#import "MainTableViewCellBase.h"
#import "RankProductCell.h"
#import "DefaultProductCell.h"

@interface MainViewController : UIViewController

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UISegmentedControl *typeSegment;
@property (nonatomic, copy) ArrayCompletion reloadRetultBlock;

@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@end
