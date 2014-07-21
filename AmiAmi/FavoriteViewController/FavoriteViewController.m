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
