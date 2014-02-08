//
//  ProductViewController.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/2/5.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "ProductViewController.h"

@interface ProductViewController (Private)
- (void)productTableViewSetting;
- (void)makeRecordCellTypeArray;
-(NSString*) chooseProductTypeText : (NSString*) recordString;
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

- (void)productTableViewSetting {
    [_productsTableView registerClass:[CurrentProductInfoCell class] forCellReuseIdentifier:@"CurrentProductInfoCell"];
    [_productsTableView registerClass:[OtherProductsCell class] forCellReuseIdentifier:@"OtherProductsCell"];
    [_productsTableView setBackgroundView:nil];
    [_productsTableView setBackgroundColor:[UIColor clearColor]];
}

- (void)makeRecordCellTypeArray {
    recordCellTypeArray = [[NSMutableArray alloc] init];
    
    if ([productInfoDictionary objectForKey:@"Relation"]) [recordCellTypeArray addObject:@"Relation"];
    if ([productInfoDictionary objectForKey:@"AlsoLike"]) [recordCellTypeArray addObject:@"AlsoLike"];
    if ([productInfoDictionary objectForKey:@"AlsoBuy"]) [recordCellTypeArray addObject:@"AlsoBuy"];
    if ([productInfoDictionary objectForKey:@"Popular"]) [recordCellTypeArray addObject:@"Popular"];
}

-(NSString*) chooseProductTypeText : (NSString*) recordString {
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [recordCellTypeArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"CurrentProductInfoCell";
        CurrentProductInfoCell *cell = (CurrentProductInfoCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        [cell.currentProductImageView setImageWithURL:[[productInfoDictionary objectForKey:@"CurrentProduct"] objectForKey:@"Thumbnail"]
                                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                            }];
        [cell.currentProductTitleTextView setText:[[productInfoDictionary objectForKey:@"CurrentProduct"] objectForKey:@"Title"]];
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"OtherProductsCell";
        OtherProductsCell *cell = (OtherProductsCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        NSInteger fixIndex = indexPath.row - 1;
        
        [cell.productTypeLabel setText:[self chooseProductTypeText:[recordCellTypeArray objectAtIndex:fixIndex]]];
        
        cell.productsInfoArray = [productInfoDictionary objectForKey:[recordCellTypeArray objectAtIndex:fixIndex]];
        [cell.productCollectionView reloadData];
        
        [cell setOnClickCollectionCell:^(NSDictionary *result) {
            ProductViewController *next = [[ProductViewController alloc] init];
            next.productInfoDictionary = result;
            [self.navigationController pushViewController:next animated:YES];
        }];
        
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 188.0f;
    } else {
        return 171.0f;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        NSMutableArray *photos = [NSMutableArray array];
        
        for (NSString *imageURLString in [productInfoDictionary objectForKey:@"ProductImages"]) {
            MyPhoto *eachPhoto = [[MyPhoto alloc] initWithImageURL:[NSURL URLWithString:imageURLString]];
            [photos addObject:eachPhoto];
        }
        
        MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:photos];
        
        EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
        [self.navigationController pushViewController:photoController animated:YES];
    }
    
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self productTableViewSetting];
    
    [self makeRecordCellTypeArray];
}

@end
