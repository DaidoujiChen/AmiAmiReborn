//
//  MainViewController+TableViewHandler.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/7/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "MainViewController+TableViewHandler.h"

#define eachInfo self.dataArray[indexPath.section]

@implementation MainViewController (TableViewHandler)

#pragma mark - UITableViewDataSource

-(NSInteger) numberOfSectionsInTableView : (UITableView*) tableView {
    return [self.dataArray count];
}

-(NSInteger) tableView : (UITableView*) tableView numberOfRowsInSection : (NSInteger) section {
    return 1;
}

-(UITableViewCell*) tableView : (UITableView*) tableView cellForRowAtIndexPath : (NSIndexPath*) indexPath {

    static NSString *CellIdentifier;
    
    MainTableViewCellBase *cell;
    
    if (self.typeSegment.selectedSegmentIndex) {
        
        CellIdentifier = @"DefaultProductCell";
        cell = (DefaultProductCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
    } else {
        
        CellIdentifier = @"RankProductCell";
        cell = (RankProductCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.rankImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ranking_%d.png", (int)indexPath.section + 1]];
        
    }
    
    [cell.thumbnailImageView setImageWithURL:[NSURL URLWithString:eachInfo[@"Thumbnail"]]
                            placeholderImage:nil
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                       if (error) NSLog(@"%@", error);
                                   }];
    
    cell.titleTextView.text = eachInfo[@"Title"];
    return cell;
    
}

#pragma mark - UITableViewDelegate

-(CGFloat) tableView : (UITableView*) tableView heightForRowAtIndexPath : (NSIndexPath*) indexPath {
    
    if (self.typeSegment.selectedSegmentIndex) {
        return 160.0f;
    } else {
        return 180.0f;
    }
    
}

-(void) tableView : (UITableView*) tableView didSelectRowAtIndexPath : (NSIndexPath*) indexPath {

    NSString *urlString = [GlobalFunctions fixProductURL:eachInfo[@"URL"]];
    
    @weakify(self);
    [AmiAmiParser parseProductInfo:urlString completion:^(AmiAmiParserStatus status, NSDictionary *result) {
        @strongify(self);
        
        if (status) {
            
            [GlobalFunctions addToHistory:eachInfo];

            ProductViewController *next = [ProductViewController new];
            NSMutableDictionary *productDictionary = [NSMutableDictionary dictionaryWithDictionary:result];
            [productDictionary setObject:eachInfo forKey:@"CurrentProduct"];
            next.productInfoDictionary = productDictionary;
            [self.navigationController pushViewController:next animated:YES];
            
        }
        
    }];
    
}

@end
