//
//  AppDelegate.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    OSNavigationController *navi = [[OSNavigationController alloc] init];
    MainViewController *next = [[MainViewController alloc] init];
    [navi pushViewController:next animated:NO];
    
    UIView *backgroundViews = [[UIView alloc] initWithFrame:navi.view.bounds];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:backgroundViews.bounds];
    [backgroundImage setImage:[UIImage imageNamed:@"background.jpg"]];
    [backgroundViews addSubview:backgroundImage];
    FXBlurView *blurView = [[FXBlurView alloc] initWithFrame:backgroundViews.bounds];
    [blurView setBlurRadius:20.0f];
    [blurView setDynamic:NO];
    [backgroundViews addSubview:blurView];
    
    [navi.view insertSubview:backgroundViews atIndex:0];
    
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
    return YES;
}

- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation: (id)annotation {
    return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
