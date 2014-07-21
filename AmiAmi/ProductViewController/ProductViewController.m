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
    
    if (productInfoDictionary[@"Relation"]) [recordCellTypeArray addObject:@"Relation"];
    if (productInfoDictionary[@"AlsoLike"]) [recordCellTypeArray addObject:@"AlsoLike"];
    if (productInfoDictionary[@"AlsoBuy"]) [recordCellTypeArray addObject:@"AlsoBuy"];
    if (productInfoDictionary[@"Popular"]) [recordCellTypeArray addObject:@"Popular"];
    
}

#pragma mark - life cycle

-(void) viewDidLoad {
    
    [super viewDidLoad];
    
    [self productTableViewSetting];
    [self makeRecordCellTypeArray];

}

-(void) viewWillAppear : (BOOL) animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
}

@end
