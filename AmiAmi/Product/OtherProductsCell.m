//
//  OtherProductsCell.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 14/2/7.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "OtherProductsCell.h"

@implementation OtherProductsCell

@synthesize onClickCollectionCell;
@synthesize productsInfoArray;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [_productCollectionView registerClass:[ProductCollectionCell class] forCellWithReuseIdentifier:@"ProductCollectionCell"];
        [GlobalFunctions textEffect:_productTypeLabel];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [productsInfoArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ProductCollectionCell";
    ProductCollectionCell *cell = (ProductCollectionCell*) [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *eachInfo = [productsInfoArray objectAtIndex:indexPath.row];
    
    FICDPhoto *photo = [[FICDPhoto alloc] init];
    [photo setSourceImageURL:[NSURL URLWithString:[eachInfo objectForKey:@"Thumbnail"]]];
    
    [[FICImageCache sharedImageCache] retrieveImageForEntity:photo withFormatName:FICDPhotoSquareImage32BitBGRFormatName completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
        cell.productImageView.image = image;
    }];
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *eachInfo = [productsInfoArray objectAtIndex:indexPath.row];
    
    NSString *urlString = [GlobalFunctions fixProductURL:[eachInfo objectForKey:@"URL"]];
    
    [AmiAmiParser parseProduct:urlString completion:^(AmiAmiParserStatus status, NSDictionary *result) {
        if (status) {
            NSMutableDictionary *productDictionary = [NSMutableDictionary dictionaryWithDictionary:result];
            [productDictionary setObject:eachInfo forKey:@"CurrentProduct"];
            onClickCollectionCell(productDictionary);
        }
    }];

}

@end
