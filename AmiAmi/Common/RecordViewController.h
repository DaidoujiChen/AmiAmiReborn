//
//  RecordViewController.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/4/7.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RelationCell.h"
#import "ProductViewController.h"

@interface RecordViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *dataSourceNameString;

@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@end
