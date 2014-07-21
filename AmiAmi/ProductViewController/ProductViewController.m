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
    
    self.recordCellTypeArray = [NSMutableArray new];
    
    if (self.productInfoDictionary[@"Relation"]) [self.recordCellTypeArray addObject:@"Relation"];
    if (self.productInfoDictionary[@"AlsoLike"]) [self.recordCellTypeArray addObject:@"AlsoLike"];
    if (self.productInfoDictionary[@"AlsoBuy"]) [self.recordCellTypeArray addObject:@"AlsoBuy"];
    if (self.productInfoDictionary[@"Popular"]) [self.recordCellTypeArray addObject:@"Popular"];
    
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
