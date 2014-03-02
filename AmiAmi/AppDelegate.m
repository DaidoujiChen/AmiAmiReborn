//
//  AppDelegate.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/1/21.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Private)
- (UIView *)makeBackgroundViews:(OSNavigationController *)navigationController;
-(void) initImageCacheSetting;
@end

@implementation AppDelegate

#pragma mark - FICImageCacheDelegate

- (void)imageCache:(FICImageCache *)imageCache wantsSourceImageForEntity:(id <FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageRequestCompletionBlock)completionBlock {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSURL *requestURL = [entity sourceImageURLWithFormatName:formatName];
        UIImageView *requestImageView = [[UIImageView alloc] init];
        __weak UIImageView *weakRequestImageView = requestImageView;

        objc_setAssociatedObject(self, (__bridge const void *)requestImageView, requestImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [requestImageView setImageWithURL:requestURL
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        completionBlock(image);
                                        objc_setAssociatedObject(self, (__bridge const void *)weakRequestImageView, nil, OBJC_ASSOCIATION_ASSIGN);
                                    });
                                }];
        
    });
}

#pragma mark - private

- (UIView *)makeBackgroundViews:(OSNavigationController *)navigationController {
    UIView *backgroundViews = [[UIView alloc] initWithFrame:navigationController.view.bounds];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:backgroundViews.bounds];
    [backgroundImage setImage:[UIImage imageNamed:@"background.jpg"]];
    [backgroundViews addSubview:backgroundImage];
    FXBlurView *blurView = [[FXBlurView alloc] initWithFrame:backgroundViews.bounds];
    [blurView setBlurRadius:20.0f];
    [blurView setDynamic:NO];
    [backgroundViews addSubview:blurView];
    return backgroundViews;
}

-(void) initImageCacheSetting {
    NSMutableArray *mutableImageFormats = [NSMutableArray array];
    
    NSInteger squareImageFormatMaximumCount = 400;
    FICImageFormatDevices squareImageFormatDevices = FICImageFormatDevicePhone;
    
    FICImageFormat *squareImageFormat32BitBGR = [FICImageFormat formatWithName:FICDPhotoSquareImage32BitBGRFormatName
                                                                        family:FICDPhotoImageFormatFamily
                                                                     imageSize:FICDPhotoSquareImageSize
                                                                         style:FICImageFormatStyle32BitBGR
                                                                  maximumCount:squareImageFormatMaximumCount
                                                                       devices:squareImageFormatDevices];
    
    [mutableImageFormats addObject:squareImageFormat32BitBGR];

    FICImageCache *sharedImageCache = [FICImageCache sharedImageCache];
    [sharedImageCache setDelegate:self];
    [sharedImageCache setFormats:mutableImageFormats];
}

#pragma mark - app life cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self initImageCacheSetting];
    
    UITabBarController *tabbar = [[UITabBarController alloc] init];
    
    OSNavigationController *mainNavi = [[OSNavigationController alloc] init];
    MainViewController *main = [[MainViewController alloc] init];
    [mainNavi setTitle:@"列表"];
    [mainNavi.tabBarItem setImage:[UIImage imageNamed:@"Albums"]];
    [mainNavi pushViewController:main animated:NO];
    
    OSNavigationController *historyNavi = [[OSNavigationController alloc] init];
    HistoryViewController *history = [[HistoryViewController alloc] init];
    [historyNavi setTitle:@"歷史"];
    [historyNavi.tabBarItem setImage:[UIImage imageNamed:@"Bookmarks"]];
    [historyNavi pushViewController:history animated:NO];
    
    OSNavigationController *favoriteNavi = [[OSNavigationController alloc] init];
    FavoriteViewController *favorite = [[FavoriteViewController alloc] init];
    [favoriteNavi setTitle:@"最愛"];
    [favoriteNavi.tabBarItem setImage:[UIImage imageNamed:@"Favorites"]];
    [favoriteNavi pushViewController:favorite animated:NO];

    [mainNavi.view insertSubview:[self makeBackgroundViews:mainNavi] atIndex:0];
    [historyNavi.view insertSubview:[self makeBackgroundViews:historyNavi] atIndex:0];
    [favoriteNavi.view insertSubview:[self makeBackgroundViews:favoriteNavi] atIndex:0];
    
    [tabbar setViewControllers:@[mainNavi, historyNavi, favoriteNavi]];
    
    self.window.rootViewController = tabbar;
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
