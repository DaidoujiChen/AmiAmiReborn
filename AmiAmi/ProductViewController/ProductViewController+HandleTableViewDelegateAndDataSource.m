//
//  ProductViewController+HandleTableViewDelegateAndDataSource.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/4/9.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "ProductViewController+HandleTableViewDelegateAndDataSource.h"

@implementation ProductViewController (HandleTableViewDelegateAndDataSource)

#pragma mark - UITableViewDataSource

-(NSInteger) numberOfSectionsInTableView : (UITableView*) tableView {
    return 1;
}

-(NSInteger) tableView : (UITableView*) tableView numberOfRowsInSection : (NSInteger) section {
    return [recordCellTypeArray count] + 1;
}

-(UITableViewCell*) tableView : (UITableView*) tableView cellForRowAtIndexPath : (NSIndexPath*) indexPath {
    
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"CurrentProductInfoCell";
        CurrentProductInfoCell *cell = (CurrentProductInfoCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        [cell.currentProductImageView setImageWithURL:[NSURL URLWithString:[[productInfoDictionary objectForKey:@"CurrentProduct"] objectForKey:@"Thumbnail"]]
                                     placeholderImage:nil
                                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                                if (error) NSLog(@"%@", error);
                                            }];
        
        [cell.currentProductTitleTextView setText:[[productInfoDictionary objectForKey:@"CurrentProduct"] objectForKey:@"Title"]];
        
        NSMutableString *productInformationString = [NSMutableString string];
        
        for (NSDictionary *eachInformation in [productInfoDictionary objectForKey:@"ProductInformation"]) {
            [productInformationString appendFormat:@"%@:%@\n", [eachInformation objectForKey:@"Title"], [eachInformation objectForKey:@"Content"]];
        }
        
        [cell.currentProductInformationTextView setText:productInformationString];
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"OtherProductsCell";
        OtherProductsCell *cell = (OtherProductsCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        NSInteger fixIndex = indexPath.row - 1;
        
        [cell.productTypeLabel setText:chooseProductTypeText([recordCellTypeArray objectAtIndex:fixIndex])];
        
        cell.productsInfoArray = [productInfoDictionary objectForKey:[recordCellTypeArray objectAtIndex:fixIndex]];
        [cell.productCollectionView reloadData];
        
        [cell setOnClickCollectionCell:^(NSDictionary *result) {
            ProductViewController *next = [ProductViewController new];
            next.productInfoDictionary = result;
            [self.navigationController pushViewController:next animated:YES];
        }];
        
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate

-(CGFloat) tableView : (UITableView*) tableView heightForRowAtIndexPath : (NSIndexPath*) indexPath {
    
    if (indexPath.row == 0) {
        return 228.0f;
    } else {
        return 141.0f;
    }
    
}

-(void) tableView : (UITableView*) tableView didSelectRowAtIndexPath : (NSIndexPath*) indexPath {
    
    if (indexPath.row == 0) {
        NSMutableArray *photos = [NSMutableArray array];
        
        for (NSString *imageURLString in [productInfoDictionary objectForKey:@"ProductImages"]) {
            MyPhoto *eachPhoto = [[MyPhoto alloc] initWithImageURL:[NSURL URLWithString:imageURLString]];
            [photos addObject:eachPhoto];
        }
        
        if ([photos count]) {
            MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:photos];
            
            EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
            [self.navigationController pushViewController:photoController animated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"這個商品沒有圖片呦"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"確定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }
    
}

#pragma mark - private

NSString* chooseProductTypeText(NSString* recordString) {
    if ([recordString isEqualToString:@"Relation"]) {
        return @"相關商品";
    } else if ([recordString isEqualToString:@"AlsoLike"]) {
        return @"你可能也會喜歡";
    } else if ([recordString isEqualToString:@"AlsoBuy"]) {
        return @"你可能也會想買";
    } else {
        return @"熱門商品";
    }
}

@end
