//
//  RecordViewController.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/4/7.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()
-(void) dataTableViewSetting;
@end

@implementation RecordViewController

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private

-(void) dataTableViewSetting {
    [self.dataTableView registerClass:[RelationCell class] forCellReuseIdentifier:@"RelationCell"];
    [self.dataTableView setBackgroundView:nil];
    [self.dataTableView setBackgroundColor:[UIColor clearColor]];
}

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


#pragma mark - life cycle

-(void) viewDidLoad {
    [super viewDidLoad];
    [self dataTableViewSetting];
}

-(void) viewWillAppear : (BOOL) animated {
    [super viewWillAppear:animated];
    [self.dataTableView setDelegate:self];
    [self.dataTableView setDataSource:self];
    [self.dataTableView reloadData];
}

@end
