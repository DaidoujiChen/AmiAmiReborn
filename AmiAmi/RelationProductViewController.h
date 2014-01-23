//
//  RelationProductViewController.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/23.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"
#import "MyPhoto.h"
#import "MyPhotoSource.h"

#import "RelationCell.h"

@interface RelationProductViewController : UIViewController {
    NSDictionary *relationInfoDictionary;
}

@property (nonatomic, strong) NSDictionary *relationInfoDictionary;

@property (weak, nonatomic) IBOutlet UITableView *relationTableView;

@end
