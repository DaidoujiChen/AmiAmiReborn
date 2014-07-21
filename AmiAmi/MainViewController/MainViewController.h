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
#import "MainCell.h"
#import "RelationCell.h"

@interface MainViewController : UIViewController {
    NSArray *dataArray;
    UISegmentedControl *typeSegment;
    ArrayCompletion reloadRetultBlock;
}

@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@end