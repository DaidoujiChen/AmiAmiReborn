//
//  ProductViewController.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/2/5.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyPhoto.h"
#import "MyPhotoSource.h"

#import "CurrentProductInfoCell.h"
#import "OtherProductsCell.h"

@interface ProductViewController : UIViewController

@property (nonatomic, strong) NSDictionary *productInfoDictionary;
@property (nonatomic, strong) NSMutableArray *recordCellTypeArray;

@property (weak, nonatomic) IBOutlet UITableView *productsTableView;

@end
