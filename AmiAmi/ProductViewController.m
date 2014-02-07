//
//  ProductViewController.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/2/5.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "ProductViewController.h"

@interface ProductViewController (Private)
- (void)collectionViewSetting;
- (void)effectSetting;
- (void)initDataShow;
@end

@implementation ProductViewController

@synthesize productInfoDictionary;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - hidden status bar

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - private

- (void)initDataShow {
    [_productImageView setImageWithURL:[NSURL URLWithString:[[productInfoDictionary objectForKey:@"CurrentProduct"] objectForKey:@"Thumbnail"]]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                             }];
    [_productTitleTextView setText:[[productInfoDictionary objectForKey:@"CurrentProduct"] objectForKey:@"Title"]];
}

- (void)effectSetting {
    for (id object in _productScrollView.subviews) {
        if ([object respondsToSelector:@selector(setText:)]) {
            [GlobalFunctions textEffect:object];
        }
    }
    
    [GlobalFunctions imageEffect:_productImageView];
}

- (void)collectionViewSetting {
    [_relationCollectionView registerClass:[ProductCollectionCell class] forCellWithReuseIdentifier:@"ProductCollectionCell"];
    [_popularCollectionView registerClass:[ProductCollectionCell class] forCellWithReuseIdentifier:@"ProductCollectionCell"];
}

#pragma mark - ibaction

- (IBAction)ShowProductImagesAction:(id)sender {
    
    NSMutableArray *photos = [NSMutableArray array];
    
    for (NSString *imageURLString in [productInfoDictionary objectForKey:@"ProductImages"]) {
        MyPhoto *eachPhoto = [[MyPhoto alloc] initWithImageURL:[NSURL URLWithString:imageURLString]];
        [photos addObject:eachPhoto];
    }
    
    MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:photos];
    
    EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
    [self.navigationController pushViewController:photoController animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == _relationCollectionView) {
        return [[productInfoDictionary objectForKey:@"Relation"] count];
    } else {
        return [[productInfoDictionary objectForKey:@"Popular"] count];
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ProductCollectionCell";
    ProductCollectionCell *cell = (ProductCollectionCell*) [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *typeArray;
    
    if (collectionView == _relationCollectionView) {
        typeArray = [productInfoDictionary objectForKey:@"Relation"];
    } else {
        typeArray = [productInfoDictionary objectForKey:@"Popular"];
    }
    
    NSDictionary *eachInfo = [typeArray objectAtIndex:indexPath.row];
    
    [cell.productImageView setImageWithURL:[NSURL URLWithString:[eachInfo objectForKey:@"Thumbnail"]]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                   }];
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *typeArray;
    
    if (collectionView == _relationCollectionView) {
        typeArray = [productInfoDictionary objectForKey:@"Relation"];
    } else {
        typeArray = [productInfoDictionary objectForKey:@"Popular"];
    }
    
    NSDictionary *eachInfo = [typeArray objectAtIndex:indexPath.row];
    
    NSString *urlString = [GlobalFunctions specProductStringFromThumbnail:[eachInfo objectForKey:@"Thumbnail"]];

    [AmiAmiParser parseProduct:urlString completion:^(AmiAmiParserStatus status, NSDictionary *result) {
        
        if (status) {
            ProductViewController *next = [[ProductViewController alloc] init];
            NSMutableDictionary *productDictionary = [NSMutableDictionary dictionaryWithDictionary:result];
            [productDictionary setObject:eachInfo forKey:@"CurrentProduct"];
            next.productInfoDictionary = productDictionary;
            [self.navigationController pushViewController:next animated:YES];
        }

    }];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self collectionViewSetting];
    
    [self effectSetting];
    
    [self initDataShow];
}

-(void) viewDidAppear:(BOOL)animated {
    [_productScrollView setContentSize:CGSizeMake(320, 568)];
}

@end
