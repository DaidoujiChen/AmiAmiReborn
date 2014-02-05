//
//  MainViewController.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController (Private)
-(void) typeChangeAction;
-(void) loadRankData;
-(void) loadAllBiShoJoData;
@end

@implementation MainViewController

@synthesize dataArray;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - hidden status bar

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - private

-(void) loadRankData {
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    [AmiAmiParser parseBiShoJoRank:^(AmiAmiParserStatus status, NSArray *result) {
        if (status) {
            self.dataArray = result;
            [_dataTableView reloadData];
        }
        
        [SVProgressHUD dismiss];
    }];
}

-(void) loadAllBiShoJoData {
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    [AmiAmiParser parseAllBiShouJo:^(AmiAmiParserStatus status, NSArray *result) {
        if (status) {
            self.dataArray = result;
            [_dataTableView reloadData];
        }
        
        [SVProgressHUD dismiss];
    }];
}

-(void) typeChangeAction {
    switch (typeSegment.selectedSegmentIndex) {
        case 0:
            [self loadRankData];
            break;
        case 1:
            [self loadAllBiShoJoData];
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (typeSegment.selectedSegmentIndex) {
        case 0:
        {
            static NSString *CellIdentifier = @"MainCell";
            MainCell *cell = (MainCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            NSDictionary *eachInfo = [dataArray objectAtIndex:indexPath.section];
            
            cell.rankImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ranking_%d.png", (int)indexPath.section + 1]];
            [cell.thumbnailImageView setImageWithURL:[NSURL URLWithString:[eachInfo objectForKey:@"Thumbnail"]]
                                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
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
            
            NSDictionary *eachInfo = [dataArray objectAtIndex:indexPath.section];
            
            [cell.thumbnailImageView setImageWithURL:[NSURL URLWithString:[eachInfo objectForKey:@"Thumbnail"]]
                                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *eachInfo = [dataArray objectAtIndex:indexPath.section];
    
    NSString *urlString = [GlobalFunctions specProductStringFromThumbnail:[eachInfo objectForKey:@"Thumbnail"]];
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    [AmiAmiParser parseProduct:urlString completion:^(AmiAmiParserStatus status, NSDictionary *result) {
        
        if (status) {
            ProductViewController *next = [[ProductViewController alloc] init];
            NSMutableDictionary *productDictionary = [NSMutableDictionary dictionaryWithDictionary:result];
            [productDictionary setObject:eachInfo forKey:@"CurrentProduct"];
            next.productInfoDictionary = productDictionary;
            [self.navigationController pushViewController:next animated:YES];
        }
        
        [SVProgressHUD dismiss];
    }];
    
    
}


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [_dataTableView registerClass:[MainCell class] forCellReuseIdentifier:@"MainCell"];
    [_dataTableView registerClass:[RelationCell class] forCellReuseIdentifier:@"RelationCell"];
    [_dataTableView setBackgroundView:nil];
    [_dataTableView setBackgroundColor:[UIColor clearColor]];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                 target:self
                                                                                 action:@selector(typeChangeAction)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    typeSegment = [[UISegmentedControl alloc] initWithItems:@[@"排名", @"全部"]];
    [typeSegment setSelectedSegmentIndex:0];
    [typeSegment addTarget:self action:@selector(typeChangeAction) forControlEvents:UIControlEventValueChanged];
    [typeSegment sizeToFit];
    self.navigationItem.titleView = typeSegment;
}

-(void) viewDidAppear:(BOOL)animated {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self loadRankData];
    });
}

@end
