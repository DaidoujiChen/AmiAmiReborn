//
//  FavoriteViewController.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/3/1.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "FavoriteViewController.h"

@interface FavoriteViewController (Private)
- (void)favoriteTableViewSetting;
@end

@implementation FavoriteViewController

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private

- (void)favoriteTableViewSetting {
    [self.favoriteTableView registerClass:[RelationCell class] forCellReuseIdentifier:@"RelationCell"];
    [self.favoriteTableView setBackgroundView:nil];
    [self.favoriteTableView setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LWPArray(@"Favorite") count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *eachInfo = [[[LWPArray(@"Favorite") reverseObjectEnumerator] allObjects] objectAtIndex:indexPath.row];
    
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
    
    NSDictionary *eachInfo = [[[LWPArray(@"Favorite") reverseObjectEnumerator] allObjects] objectAtIndex:indexPath.row];
    
    NSString *urlString = [GlobalFunctions fixProductURL:[eachInfo objectForKey:@"URL"]];
    
    [AmiAmiParser parseProduct:urlString completion:^(AmiAmiParserStatus status, NSDictionary *result) {
        
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [LWPArray(@"Favorite") removeObjectAtIndex:[LWPArray(@"Favorite") count] - 1 - indexPath.row];
        [tableView reloadData];
    }
}


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self favoriteTableViewSetting];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.favoriteTableView reloadData];
}


@end
