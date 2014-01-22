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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [rankInfoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RankCell";
    RankCell *cell = (RankCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    NSDictionary *eachInfo = [rankInfoArray objectAtIndex:indexPath.row];
    
    cell.rankImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ranking_%d.png", indexPath.row + 1]];
    [cell.thumbnailImageView setImageWithURL:[NSURL URLWithString:[eachInfo objectForKey:@"Thumbnail"]]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                   }];
    
    cell.thumbnailImageView.layer.masksToBounds = NO;
    cell.thumbnailImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.thumbnailImageView.layer.borderWidth = 3.5f;
    cell.thumbnailImageView.layer.contentsScale = [UIScreen mainScreen].scale;
    cell.thumbnailImageView.layer.shadowOpacity = 0.75f;
    cell.thumbnailImageView.layer.shadowRadius = 5.0f;
    cell.thumbnailImageView.layer.shadowOffset = CGSizeZero;
    cell.thumbnailImageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.thumbnailImageView.bounds].CGPath;
    cell.thumbnailImageView.layer.shouldRasterize = YES;
    
    cell.titleTextView.text = [eachInfo objectForKey:@"Title"];

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_rankTableView registerClass:[RankCell class] forCellReuseIdentifier:@"RankCell"];
    [_rankTableView setBackgroundView:nil];
    [_rankTableView setBackgroundColor:[UIColor clearColor]];
    
    [_blurView setBlurRadius:30.0f];
    
    [AmiAmiParser parseRankCategory:1 completion:^(AmiAmiParserStatus status, NSArray *result) {
        if (status) {
            self.rankInfoArray = result;
            [_rankTableView reloadData];
        }
    }];
}

@end
