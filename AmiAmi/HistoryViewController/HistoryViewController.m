//
//  HistoryViewController.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/3/1.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@end

@implementation HistoryViewController

-(id) initWithNibName : (NSString*) nibNameOrNil bundle : (NSBundle*) nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.dataSourceNameString = @"History";
        
    }
    return self;
    
}

-(void) viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"歷史"];
    
}

@end
