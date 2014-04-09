//
//  MainViewController+HandleTableViewDelegateAndDataSource.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/4/9.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "MainViewController+HandleTableViewDelegateAndDataSource.h"

@implementation MainViewController (HandleTableViewDelegateAndDataSource)

#pragma mark - UITableViewDataSource

-(NSInteger) numberOfSectionsInTableView : (UITableView*) tableView {
    return [dataArray count];
}

-(NSInteger) tableView : (UITableView*) tableView numberOfRowsInSection : (NSInteger) section {
    return 1;
}

-(UITableViewCell*) tableView : (UITableView*) tableView cellForRowAtIndexPath : (NSIndexPath*) indexPath {
    
    NSDictionary *eachInfo = [dataArray objectAtIndex:indexPath.section];
    
    switch (typeSegment.selectedSegmentIndex) {
        case 0:
        {
            static NSString *CellIdentifier = @"MainCell";
            MainCell *cell = (MainCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            cell.rankImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ranking_%d.png", (int)indexPath.section + 1]];
            
            [GlobalFunctions getThumbnailImageFromURL:[NSURL URLWithString:[eachInfo objectForKey:@"Thumbnail"]]
                                           completion:^(UIImage *image) {
                                               cell.thumbnailImageView.image = image;
                                           }];
            
            cell.titleTextView.text = [eachInfo objectForKey:@"Title"];
            
            return cell;
            break;
        }
            
        case 1:
        {
            static NSString *CellIdentifier = @"RelationCell";
            RelationCell *cell = (RelationCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            [GlobalFunctions getThumbnailImageFromURL:[NSURL URLWithString:[eachInfo objectForKey:@"Thumbnail"]]
                                           completion:^(UIImage *image) {
                                               cell.thumbnailImageView.image = image;
                                           }];
            
            cell.titleTextView.text = [eachInfo objectForKey:@"Title"];
            
            return cell;
            break;
        }
            
        default:
            return nil;
            break;
    }
    
    
}

#pragma mark - UITableViewDelegate

-(CGFloat) tableView : (UITableView*) tableView heightForRowAtIndexPath : (NSIndexPath*) indexPath {
    switch (typeSegment.selectedSegmentIndex) {
        case 0:
            return 180.0f;
            break;
        case 1:
            return 160.0f;
            break;
        default:
            return 0;
            break;
    }
}

-(void) tableView : (UITableView*) tableView didSelectRowAtIndexPath : (NSIndexPath*) indexPath {
    
    NSDictionary *eachInfo = [dataArray objectAtIndex:indexPath.section];
    
    NSString *urlString = [GlobalFunctions fixProductURL:[eachInfo objectForKey:@"URL"]];
    
    [AmiAmiParser parseProductInfo:urlString completion:^(AmiAmiParserStatus status, NSDictionary *result) {
        
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
