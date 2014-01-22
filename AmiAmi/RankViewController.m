//
//  RankViewController.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "RankViewController.h"

@interface RankViewController ()

@end

@implementation RankViewController

@synthesize rankInfoArray;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - hidden status bar

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [rankInfoArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RankCell";
    RankCell *cell = (RankCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    NSDictionary *eachInfo = [rankInfoArray objectAtIndex:indexPath.section];
    
    cell.rankImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ranking_%d.png", indexPath.section + 1]];
    [cell.thumbnailImageView setImageWithURL:[NSURL URLWithString:[eachInfo objectForKey:@"Thumbnail"]]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                   }];
    
    cell.titleTextView.text = [eachInfo objectForKey:@"Title"];

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SpecProductViewController *next = [[SpecProductViewController alloc] init];
    [self.navigationController pushViewController:next animated:YES];
}


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_rankTableView registerClass:[RankCell class] forCellReuseIdentifier:@"RankCell"];
    [_rankTableView setBackgroundView:nil];
    [_rankTableView setBackgroundColor:[UIColor clearColor]];
    
    [AmiAmiParser parseRankCategory:1 completion:^(AmiAmiParserStatus status, NSArray *result) {
        if (status) {
            self.rankInfoArray = result;
            [_rankTableView reloadData];
        }
    }];
}

-(void) viewWillAppear:(BOOL)animated {
    [self.view setBackgroundColor:[UIColor clearColor]];
}

-(void) viewWillDisappear:(BOOL)animated {
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

@end
