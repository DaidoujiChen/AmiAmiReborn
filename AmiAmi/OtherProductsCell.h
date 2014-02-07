//
//  OtherProductsCell.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 14/2/7.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"

#import "UITableViewCellBase.h"
#import "ProductCollectionCell.h"

@interface OtherProductsCell : UITableViewCellBase {
    NSArray *productsInfoArray;
    void (^clickCellBlock)(NSDictionary *result);
}

@property (nonatomic, strong) NSArray *productsInfoArray;
@property (nonatomic, copy) void (^clickCellBlock)(NSDictionary *result);

@property (weak, nonatomic) IBOutlet UILabel *productTypeLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;


@end
