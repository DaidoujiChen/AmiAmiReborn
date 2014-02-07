//
//  ProductViewController.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/2/5.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "ProductViewController.h"

@interface ProductViewController (Private)
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableDataArray count] + 1;
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
        
        if ([[tableDataArray objectAtIndex:fixIndex] isEqualToString:@"Relation"]) {
            [cell.productTypeLabel setText:@"相關商品"];
        } else if ([[tableDataArray objectAtIndex:fixIndex] isEqualToString:@"AlsoLike"]) {
            [cell.productTypeLabel setText:@"你也會喜歡"];
        } else {
            [cell.productTypeLabel setText:@"熱門商品"];
        }
        
        cell.productsInfoArray = [productInfoDictionary objectForKey:[tableDataArray objectAtIndex:fixIndex]];
        
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 254.0f;
    } else {
        return 200.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_productsTableView registerClass:[CurrentProductInfoCell class] forCellReuseIdentifier:@"CurrentProductInfoCell"];
    [_productsTableView registerClass:[OtherProductsCell class] forCellReuseIdentifier:@"OtherProductsCell"];
    [_productsTableView setBackgroundView:nil];
    [_productsTableView setBackgroundColor:[UIColor clearColor]];
    
    tableDataArray = [[NSMutableArray alloc] init];
    
    if ([productInfoDictionary objectForKey:@"Relation"]) [tableDataArray addObject:@"Relation"];
    if ([productInfoDictionary objectForKey:@"AlsoLike"]) [tableDataArray addObject:@"AlsoLike"];
    if ([productInfoDictionary objectForKey:@"Popular"]) [tableDataArray addObject:@"Popular"];
}

@end
