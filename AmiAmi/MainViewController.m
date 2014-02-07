//
//  MainViewController.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) void (^reloadRetultBlock)(AmiAmiParserStatus status, NSArray *result);
@end

@interface MainViewController (Private)
- (void)createNavigationRightButton;
- (void)createNavigationTitleSegment;
- (void)dataTableViewSetting;

-(void) typeChangeOrReloadAction;
-(void) loadRankData;
-(void) loadAllBiShoJoData;
@end

@implementation MainViewController

@synthesize dataArray;
@synthesize reloadRetultBlock;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - hidden status bar

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - private

#pragma mark ui create

- (void)dataTableViewSetting {
    [_dataTableView registerClass:[MainCell class] forCellReuseIdentifier:@"MainCell"];
    [_dataTableView registerClass:[RelationCell class] forCellReuseIdentifier:@"RelationCell"];
    [_dataTableView setBackgroundView:nil];
    [_dataTableView setBackgroundColor:[UIColor clearColor]];
}

- (void)createNavigationRightButton {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                 target:self
                                                                                 action:@selector(typeChangeOrReloadAction)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)createNavigationTitleSegment {
    typeSegment = [[UISegmentedControl alloc] initWithItems:@[@"排名", @"全部"]];
    [typeSegment setSelectedSegmentIndex:0];
    [typeSegment addTarget:self action:@selector(typeChangeOrReloadAction) forControlEvents:UIControlEventValueChanged];
    [typeSegment sizeToFit];
    self.navigationItem.titleView = typeSegment;
}

#pragma mark function

-(void) typeChangeOrReloadAction {
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

-(void) loadRankData {
    [AmiAmiParser parseBiShoJoRank:reloadRetultBlock];
}

-(void) loadAllBiShoJoData {
    [AmiAmiParser parseAllBiShouJo:reloadRetultBlock];
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

    [AmiAmiParser parseProduct:urlString completion:^(AmiAmiParserStatus status, NSDictionary *result) {
        
        if (status) {
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

    [self dataTableViewSetting];
    
    [self createNavigationRightButton];
    [self createNavigationTitleSegment];
}

-(void) viewDidAppear:(BOOL)animated {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        __weak MainViewController *weakSelf = self;
        
        reloadRetultBlock = ^(AmiAmiParserStatus status, NSArray *result) {
            if (status) {
                weakSelf.dataArray = result;
                [weakSelf.dataTableView reloadData];
                [weakSelf.dataTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                              atScrollPosition:UITableViewScrollPositionTop
                                                      animated:YES];
            }
        };
        
        [self typeChangeOrReloadAction];
    });
}

@end
