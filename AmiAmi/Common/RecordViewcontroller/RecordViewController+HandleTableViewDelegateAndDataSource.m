//
//  RecordViewController+HandleTableViewDelegateAndDataSource.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/4/9.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "RecordViewController+HandleTableViewDelegateAndDataSource.h"

@implementation RecordViewController (HandleTableViewDelegateAndDataSource)

#pragma mark - UITableViewDataSource

-(NSInteger) numberOfSectionsInTableView : (UITableView*) tableView {
    return 1;
}

-(NSInteger) tableView : (UITableView*) tableView numberOfRowsInSection : (NSInteger) section {
    return [LWPArray(self.dataSourceNameString) count];
}

-(UITableViewCell*) tableView : (UITableView*) tableView cellForRowAtIndexPath : (NSIndexPath*) indexPath {
    
    NSDictionary *eachInfo = [[[LWPArray(self.dataSourceNameString) reverseObjectEnumerator] allObjects] objectAtIndex:indexPath.row];
    
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
    
    
}

#pragma mark - UITableViewDelegate

-(CGFloat) tableView : (UITableView*) tableView heightForRowAtIndexPath : (NSIndexPath*) indexPath {
    return 160.0f;
}

-(void) tableView : (UITableView*) tableView didSelectRowAtIndexPath : (NSIndexPath*) indexPath {
    
    NSDictionary *eachInfo = [[[LWPArray(self.dataSourceNameString) reverseObjectEnumerator] allObjects] objectAtIndex:indexPath.row];
    
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
