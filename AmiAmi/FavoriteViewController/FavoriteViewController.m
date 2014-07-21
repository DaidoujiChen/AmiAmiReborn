//
//  FavoriteViewController.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/3/1.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "FavoriteViewController.h"

@interface FavoriteViewController ()
@end

@implementation FavoriteViewController

-(id) initWithNibName : (NSString*) nibNameOrNil bundle : (NSBundle*) nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.dataSourceNameString = @"Favorite";
        
    }
    return self;
    
}

-(void) viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"最愛"];
    
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [FavoriteArray removeObjectAtIndex:[FavoriteArray count] - 1 - indexPath.row];
        [tableView reloadData];
    }
}

@end
