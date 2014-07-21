//
//  OtherProductsCell+CollectionViewHandler.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/7/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "OtherProductsCell+CollectionViewHandler.h"

@implementation OtherProductsCell (CollectionViewHandler)

#pragma mark - UICollectionViewDataSource

-(NSInteger) numberOfSectionsInCollectionView : (UICollectionView*) collectionView {
    return 1;
}

-(NSInteger) collectionView : (UICollectionView*) collectionView numberOfItemsInSection : (NSInteger) section {
    return [self.productsInfoArray count];
}

-(UICollectionViewCell*) collectionView : (UICollectionView*) collectionView cellForItemAtIndexPath : (NSIndexPath*) indexPath {
    
    static NSString *CellIdentifier = @"ProductCollectionCell";
    ProductCollectionCell *cell = (ProductCollectionCell*) [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *eachInfo = self.productsInfoArray[indexPath.row];
    
    [cell.productImageView setImageWithURL:[NSURL URLWithString:eachInfo[@"Thumbnail"]]
                          placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                     if (error) NSLog(@"%@", error);
                                 }];
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate

-(void) collectionView : (UICollectionView*) collectionView didSelectItemAtIndexPath : (NSIndexPath*) indexPath {
    
    NSDictionary *eachInfo = self.productsInfoArray[indexPath.row];
    
    NSString *urlString = [GlobalFunctions fixProductURL:eachInfo[@"URL"]];
    
    [AmiAmiParser parseProductInfo:urlString completion:^(AmiAmiParserStatus status, NSDictionary *result) {
        if (status) {
            
            [GlobalFunctions addToHistory:eachInfo];
            
            NSMutableDictionary *productDictionary = [NSMutableDictionary dictionaryWithDictionary:result];
            [productDictionary setObject:eachInfo forKey:@"CurrentProduct"];
            self.onClickCollectionCell(productDictionary);
        }
    }];
    
}


@end
