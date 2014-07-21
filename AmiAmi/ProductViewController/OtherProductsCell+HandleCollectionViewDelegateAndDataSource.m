//
//  OtherProductsCell+HandleCollectionViewDelegateAndDataSource.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/4/9.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "OtherProductsCell+HandleCollectionViewDelegateAndDataSource.h"

@implementation OtherProductsCell (HandleCollectionViewDelegateAndDataSource)

#pragma mark - UICollectionViewDataSource

-(NSInteger) numberOfSectionsInCollectionView : (UICollectionView*) collectionView {
    return 1;
}

-(NSInteger) collectionView : (UICollectionView*) collectionView numberOfItemsInSection : (NSInteger) section {
    return [productsInfoArray count];
}

-(UICollectionViewCell*) collectionView : (UICollectionView*) collectionView cellForItemAtIndexPath : (NSIndexPath*) indexPath {
    
    static NSString *CellIdentifier = @"ProductCollectionCell";
    ProductCollectionCell *cell = (ProductCollectionCell*) [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *eachInfo = productsInfoArray[indexPath.row];
    
    [cell.productImageView setImageWithURL:[NSURL URLWithString:eachInfo[@"Thumbnail"]]
                          placeholderImage:nil
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                     if (error) NSLog(@"%@", error);
                                 }];
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate

-(void) collectionView : (UICollectionView*) collectionView didSelectItemAtIndexPath : (NSIndexPath*) indexPath {
    
    NSDictionary *eachInfo = productsInfoArray[indexPath.row];
    
    NSString *urlString = [GlobalFunctions fixProductURL:eachInfo[@"URL"]];
    
    [AmiAmiParser parseProductInfo:urlString completion:^(AmiAmiParserStatus status, NSDictionary *result) {
        if (status) {
            
            [GlobalFunctions addToHistory:eachInfo];
            
            NSMutableDictionary *productDictionary = [NSMutableDictionary dictionaryWithDictionary:result];
            [productDictionary setObject:eachInfo forKey:@"CurrentProduct"];
            onClickCollectionCell(productDictionary);
        }
    }];
    
}


@end
