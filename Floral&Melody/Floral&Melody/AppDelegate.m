//
//  AppDelegate.m
//  Floral&Melody
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "AppDelegate.h"

#import "XLHSpecialViewController.h"

#import "WHC_NavigationController.h"

#import "FindViewController.h"

#import "RadioViewController.h"

#import "XLHMineViewController.h"

#import "FirstTimeLoginView.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
#pragma mark - XLH
    /** Initialization Of XLHSpecialTableViewController **/
    XLHSpecialViewController * Specialxlh = [[XLHSpecialViewController alloc] init];
    
    UINavigationController * SpecialNav = [[UINavigationController alloc] initWithRootViewController:Specialxlh];
    SpecialNav.tabBarItem.image = [UIImage imageNamed:@"专题"];
    SpecialNav.tabBarItem.title = @"专题";
    UIImage * XLHImage = [UIImage imageNamed:@"专题S"];
    XLHImage = [XLHImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    SpecialNav.tabBarItem.selectedImage = XLHImage;
    
#pragma mark - BF
    /** Initialization Of XLHSpecialTableViewController **/
    FindViewController * FindVC = [[FindViewController alloc] init];
    
    UINavigationController * FindNav = [[UINavigationController alloc] initWithRootViewController:FindVC];

    FindNav.tabBarItem.title = @"百科";
    FindNav.tabBarItem.image = [UIImage imageNamed:@"百科"];
    UIImage * BFImage = [UIImage imageNamed:@"百科S"];
    BFImage = [BFImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    FindNav.tabBarItem.selectedImage = BFImage;
    
#pragma mark - JMRadio
    RadioViewController * JMVC = [[RadioViewController alloc] init];
    
    UINavigationController * JMNav = [[UINavigationController alloc] initWithRootViewController:JMVC];
    
    JMNav.tabBarItem.title = @"电台";
    JMNav.tabBarItem.image = [UIImage imageNamed:@"电台"];
    UIImage * JMImage = [UIImage imageNamed:@"电台S"];
    JMImage = [JMImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    JMNav.tabBarItem.selectedImage = JMImage;

#pragma mark - Mine
    XLHMineViewController * mine = [[XLHMineViewController alloc] init];
    
    UINavigationController * mineNav = [[UINavigationController alloc] initWithRootViewController:mine];
    
    mineNav.tabBarItem.title = @"我的";
    mineNav.tabBarItem.image = [UIImage imageNamed:@"我的"];
    UIImage * mineImage = [UIImage imageNamed:@"我的S"];
    mineImage = [mineImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineNav.tabBarItem.selectedImage = mineImage;
    
    
#pragma mark - tabbarController
    UITabBarController * tabbar = [[UITabBarController alloc] init];
    tabbar.tabBar.tintColor = [UIColor blackColor];
    /** Controllers*/
    NSMutableArray * array = [NSMutableArray arrayWithObjects: SpecialNav, FindNav, JMNav, mineNav, nil];
    
    tabbar.viewControllers = array;

    //引导图
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:@"标记"];
    if ([str isEqualToString:@"有了"]==NO) {
        FirstTimeLoginView *first = [[FirstTimeLoginView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) withImageArray:[NSArray arrayWithObjects:[UIImage imageNamed:@"one-t"],[UIImage imageNamed:@"two-t"], [UIImage imageNamed:@"three-t"],[UIImage imageNamed:@"four-t"],nil]];
        [tabbar.view addSubview:first];
    }
    
    /** Set rootViewController **/
    self.window.rootViewController = tabbar;
    return YES;
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
