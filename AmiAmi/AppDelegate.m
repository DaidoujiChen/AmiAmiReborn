//
//  AppDelegate.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

- (UIView *)makeBackgroundViews:(OSNavigationController *)navigationController;

@end

@implementation AppDelegate

#pragma mark - private

- (UIView *)makeBackgroundViews:(OSNavigationController *)navigationController
{
	UIView *backgroundViews = [[UIView alloc] initWithFrame:navigationController.view.bounds];
	UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:backgroundViews.bounds];
    backgroundImage.image = [UIImage imageNamed:@"background4.png"];
	[backgroundViews addSubview:backgroundImage];
	FXBlurView *blurView = [[FXBlurView alloc] initWithFrame:backgroundViews.bounds];
    blurView.blurRadius = 20.0f;
    blurView.dynamic = NO;
	[backgroundViews addSubview:blurView];
	return backgroundViews;
}

#pragma mark - app life cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
	UITabBarController *tabbar = [UITabBarController new];
    
	OSNavigationController *mainNavi = [OSNavigationController new];
	MainViewController *main = [MainViewController new];
    mainNavi.title = @"列表";
    mainNavi.tabBarItem.image = [UIImage imageNamed:@"Albums"];
	[mainNavi pushViewController:main animated:NO];
    
	OSNavigationController *historyNavi = [OSNavigationController new];
	HistoryViewController *history = [[HistoryViewController alloc] initWithNibName:@"RecordViewController" bundle:nil];
    historyNavi.title = @"歷史";
    historyNavi.tabBarItem.image = [UIImage imageNamed:@"Bookmarks"];
	[historyNavi pushViewController:history animated:NO];
    
	OSNavigationController *favoriteNavi = [OSNavigationController new];
	FavoriteViewController *favorite = [[FavoriteViewController alloc] initWithNibName:@"RecordViewController" bundle:nil];
    favoriteNavi.title = @"最愛";
    favoriteNavi.tabBarItem.image = [UIImage imageNamed:@"Favorites"];
	[favoriteNavi pushViewController:favorite animated:NO];
    
	[mainNavi.view insertSubview:[self makeBackgroundViews:mainNavi] atIndex:0];
	[historyNavi.view insertSubview:[self makeBackgroundViews:historyNavi] atIndex:0];
	[favoriteNavi.view insertSubview:[self makeBackgroundViews:favoriteNavi] atIndex:0];
    
    tabbar.viewControllers = @[mainNavi, historyNavi, favoriteNavi];
    
	self.window.rootViewController = tabbar;
	[self.window makeKeyAndVisible];
    
	NSDictionary *dictionary = @{@"UserAgent": @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36"};
	[[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
	if (!MiscDictionary[@"typeIndex"]) {
        MiscDictionary[@"typeIndex"] = [NSNumber numberWithInt:0];
	}
    
	return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
