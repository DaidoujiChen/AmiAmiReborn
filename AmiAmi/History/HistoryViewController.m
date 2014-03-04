//
//  HistoryViewController.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/3/1.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController (Private)
- (void)historyTableViewSetting;
@end

@implementation HistoryViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private

- (void)historyTableViewSetting {
    [_historyTableView registerClass:[RelationCell class] forCellReuseIdentifier:@"RelationCell"];
    [_historyTableView setBackgroundView:nil];
    [_historyTableView setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LWPArray(@"History") count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *eachInfo = [[[LWPArray(@"History") reverseObjectEnumerator] allObjects] objectAtIndex:indexPath.row];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *eachInfo = [[[LWPArray(@"History") reverseObjectEnumerator] allObjects] objectAtIndex:indexPath.row];

    NSString *urlString = [GlobalFunctions fixProductURL:[eachInfo objectForKey:@"URL"]];
    
    [AmiAmiParser parseProduct:urlString completion:^(AmiAmiParserStatus status, NSDictionary *result) {
        
        if (status) {
            
            [GlobalFunctions addToHistory:eachInfo];
            
            ProductViewController *next = [[ProductViewController alloc] init];
            NSMutableDictionary *productDictionary = [NSMutableDictionary dictionaryWithDictionary:result];
            [productDictionary setObject:eachInfo forKey:@"CurrentProduct"];
            next.productInfoDictionary = productDictionary;
            [self.navigationController pushViewController:next animated:YES];
        }
        
    }];
    
}


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self historyTableViewSetting];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_historyTableView reloadData];
}

@end
