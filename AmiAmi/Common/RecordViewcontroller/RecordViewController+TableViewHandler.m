//
//  RecordViewController+TableViewHandler.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/7/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "RecordViewController+TableViewHandler.h"

#define dataSource LWPArray(self.dataSourceNameString)

@implementation RecordViewController (TableViewHandler)

#pragma mark - UITableViewDataSource

-(NSInteger) numberOfSectionsInTableView : (UITableView*) tableView {
    return 1;
}

-(NSInteger) tableView : (UITableView*) tableView numberOfRowsInSection : (NSInteger) section {
    return [dataSource count];
}

-(UITableViewCell*) tableView : (UITableView*) tableView cellForRowAtIndexPath : (NSIndexPath*) indexPath {
    
    NSDictionary *eachInfo = [[dataSource reverseObjectEnumerator] allObjects][indexPath.row];
    
    static NSString *CellIdentifier = @"DefaultProductCell";
    DefaultProductCell *cell = (DefaultProductCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    [cell.thumbnailImageView setImageWithURL:[NSURL URLWithString:eachInfo[@"Thumbnail"]]
                            placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                       if (error) NSLog(@"%@", error);
                                   }];
    
    cell.titleTextView.text = eachInfo[@"Title"];

    return cell;
    
    
}

#pragma mark - UITableViewDelegate

-(CGFloat) tableView : (UITableView*) tableView heightForRowAtIndexPath : (NSIndexPath*) indexPath {
    return 160.0f;
}

-(void) tableView : (UITableView*) tableView didSelectRowAtIndexPath : (NSIndexPath*) indexPath {
    
    NSDictionary *eachInfo = [[dataSource reverseObjectEnumerator] allObjects][indexPath.row];
    
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
