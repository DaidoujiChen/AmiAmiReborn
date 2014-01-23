//
//  RelationProductViewController.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/23.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "RelationProductViewController.h"

@interface RelationProductViewController ()

@end

@implementation RelationProductViewController

@synthesize relationInfoDictionary;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - hidden status bar

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"相關商品";
            break;
        case 1:
            return @"熱門商品";
            break;
        default:
            return nil;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [[relationInfoDictionary objectForKey:@"Relation"] count];
            break;
        case 1:
            return [[relationInfoDictionary objectForKey:@"Popular"] count];
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RelationCell";
    RelationCell *cell = (RelationCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    NSArray *typeArray;
    
    switch (indexPath.section) {
        case 0:
            typeArray = [relationInfoDictionary objectForKey:@"Relation"];
            break;
        case 1:
            typeArray = [relationInfoDictionary objectForKey:@"Popular"];
            break;
        default:
            break;
    }
    
    NSDictionary *eachInfo = [typeArray objectAtIndex:indexPath.row];

    [cell.thumbnailImageView setImageWithURL:[NSURL URLWithString:[eachInfo objectForKey:@"Thumbnail"]]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                   }];
    
    cell.titleTextView.text = [eachInfo objectForKey:@"Title"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *typeArray;
    
    switch (indexPath.section) {
        case 0:
            typeArray = [relationInfoDictionary objectForKey:@"Relation"];
            break;
        case 1:
            typeArray = [relationInfoDictionary objectForKey:@"Popular"];
            break;
        default:
            break;
    }
    
    NSDictionary *eachInfo = [typeArray objectAtIndex:indexPath.row];
    
    NSString *urlString = [GlobalFunctions specProductStringFromThumbnail:[eachInfo objectForKey:@"Thumbnail"]];
    
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
    
    [_relationTableView registerClass:[RelationCell class] forCellReuseIdentifier:@"RelationCell"];
    [_relationTableView setBackgroundView:nil];
    [_relationTableView setBackgroundColor:[UIColor clearColor]];
}

@end
