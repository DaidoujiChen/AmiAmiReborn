//
//  RankViewController.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "RankViewController.h"

@interface RankViewController (Private)
-(void) reloadRank;
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

#pragma mark - private

-(void) reloadRank {
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    [AmiAmiParser parseRankCategory:1 completion:^(AmiAmiParserStatus status, NSArray *result) {
        if (status) {
            self.rankInfoArray = result;
            [_rankTableView reloadData];
        }
        
        [SVProgressHUD dismiss];
    }];
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
    
    NSDictionary *eachInfo = [rankInfoArray objectAtIndex:indexPath.section];
    
    NSArray *splitArray = [[eachInfo objectForKey:@"Thumbnail"] componentsSeparatedByString:@"/"];
    
    NSString *finalString = [splitArray objectAtIndex:[splitArray count]-1];
    
    NSArray *finalArray = [finalString componentsSeparatedByString:@"."];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.amiami.jp/top/detail/detail?scode=%@", [finalArray objectAtIndex:0]];
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    [AmiAmiParser parseSpecProductImagesInURLString:urlString completion:^(AmiAmiParserStatus status, NSArray *result) {
        if (status) {
            NSMutableArray *photos = [NSMutableArray array];
            
            for (NSString *imageURLString in result) {
                MyPhoto *eachPhoto = [[MyPhoto alloc] initWithImageURL:[NSURL URLWithString:imageURLString]];
                [photos addObject:eachPhoto];
            }
            
            MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:photos];
            
            EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
            photoController.pageURL = urlString;
            [self.navigationController pushViewController:photoController animated:YES];
        }
        
        [SVProgressHUD dismiss];
    }];
    
    
}


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"美少女排行";
    
    [_rankTableView registerClass:[RankCell class] forCellReuseIdentifier:@"RankCell"];
    [_rankTableView setBackgroundView:nil];
    [_rankTableView setBackgroundColor:[UIColor clearColor]];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                 target:self
                                                                                 action:@selector(reloadRank)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void) viewDidAppear:(BOOL)animated {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        
        [AmiAmiParser parseRankCategory:1 completion:^(AmiAmiParserStatus status, NSArray *result) {
            if (status) {
                self.rankInfoArray = result;
                [_rankTableView reloadData];
            }
            
            [SVProgressHUD dismiss];
        }];
    });
}

@end
