//
//  SelectProductTypeViewController.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/3/10.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "SelectProductTypeViewController.h"

@interface SelectProductTypeViewController ()
-(void) createNavigationRightButton;
-(void) selectProductTypeTableViewSetting;
-(void) dismissSelf;
@end

@implementation SelectProductTypeViewController

@synthesize requestReloadTable;

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private

-(void) createNavigationRightButton {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                 target:self
                                                                                 action:@selector(dismissSelf)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void) selectProductTypeTableViewSetting {
    [self.selectProductTypeTableView registerClass:[DefaultCell class] forCellReuseIdentifier:@"DefaultCell"];
}

-(void) dismissSelf {
    [self dismissViewControllerAnimated:YES completion:^{
        requestReloadTable();
    }];
}

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

#pragma mark - life cycle

-(void) viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationRightButton];
    [self selectProductTypeTableViewSetting];
}

@end
