//
//  SelectProductTypeViewController+HandleTableViewDelegateAndDataSource.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/4/9.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "SelectProductTypeViewController+HandleTableViewDelegateAndDataSource.h"

#import "SelectProductTypeViewController+Components.h"

@implementation SelectProductTypeViewController (HandleTableViewDelegateAndDataSource)

#pragma mark - UITableViewDataSource

-(NSInteger) tableView : (UITableView*) tableView numberOfRowsInSection : (NSInteger) section {
    return [LWPArray(@"AllProducts") count];
}

-(UITableViewCell*) tableView : (UITableView*) tableView cellForRowAtIndexPath : (NSIndexPath*) indexPath {
    static NSString *CellIdentifier = @"DefaultCell";
    DefaultCell *cell = (DefaultCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    NSDictionary *eachDictionary = [LWPArray(@"AllProducts")  objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [eachDictionary objectForKey:@"title"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void) tableView : (UITableView*) tableView didSelectRowAtIndexPath : (NSIndexPath*) indexPath {
    [LWPDictionary(@"MISC") setObject:[NSNumber numberWithInt:indexPath.row] forKey:@"typeIndex"];
    [self dismissSelf];
}

@end
