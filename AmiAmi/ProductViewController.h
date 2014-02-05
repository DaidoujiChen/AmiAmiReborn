//
//  ProductViewController.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/2/5.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"
#import "MyPhoto.h"
#import "MyPhotoSource.h"

#import "ProductCollectionCell.h"

@interface ProductViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource> {
    NSDictionary *productInfoDictionary;
}

@property (nonatomic, strong) NSDictionary *productInfoDictionary;


@property (weak, nonatomic) IBOutlet UIScrollView *productScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UITextView *productTitleTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *relationCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *popularCollectionView;

@end
