//
//  ProductViewController.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/2/5.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "ProductViewController.h"

@interface ProductViewController ()
-(void) productTableViewSetting;
-(void) makeRecordCellTypeArray;
@end

@implementation ProductViewController

@synthesize productInfoDictionary;

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private

-(void) productTableViewSetting {
    
    [self.productsTableView registerClass:[CurrentProductInfoCell class] forCellReuseIdentifier:@"CurrentProductInfoCell"];
    [self.productsTableView registerClass:[OtherProductsCell class] forCellReuseIdentifier:@"OtherProductsCell"];
    [self.productsTableView setBackgroundView:nil];
    [self.productsTableView setBackgroundColor:[UIColor clearColor]];
    
}

-(void) makeRecordCellTypeArray {
    
    recordCellTypeArray = [NSMutableArray new];
    
    if ([productInfoDictionary objectForKey:@"Relation"]) [recordCellTypeArray addObject:@"Relation"];
    if ([productInfoDictionary objectForKey:@"AlsoLike"]) [recordCellTypeArray addObject:@"AlsoLike"];
    if ([productInfoDictionary objectForKey:@"AlsoBuy"]) [recordCellTypeArray addObject:@"AlsoBuy"];
    if ([productInfoDictionary objectForKey:@"Popular"]) [recordCellTypeArray addObject:@"Popular"];
    
}

#pragma mark - life cycle

-(void) viewDidLoad {
    
    [super viewDidLoad];
    
    [self productTableViewSetting];
    [self makeRecordCellTypeArray];
    
    [[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        [self.navigationController setNavigationBarHidden:NO];
    }];
    
}

@end
