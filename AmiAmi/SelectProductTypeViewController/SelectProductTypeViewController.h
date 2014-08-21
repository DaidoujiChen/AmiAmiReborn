//
//  SelectProductTypeViewController.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/3/10.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DefaultCell.h"

@interface SelectProductTypeViewController : UIViewController

@property (nonatomic, copy) void (^requestReloadTable)(void);

@property (weak, nonatomic) IBOutlet UITableView *selectProductTypeTableView;

@end
