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
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
#pragma mark - XLH
    /** Initialization Of XLHSpecialTableViewController **/
    XLHSpecialViewController * Specialxlh = [[XLHSpecialViewController alloc] init];
    
    UINavigationController * SpecialNav = [[UINavigationController alloc] initWithRootViewController:Specialxlh];
    
    SpecialNav.tabBarItem.title = @"专题";
    
#pragma mark - BF
    /** Initialization Of XLHSpecialTableViewController **/
    FindViewController * FindVC = [[FindViewController alloc] init];
    
    UINavigationController * FindNav = [[UINavigationController alloc] initWithRootViewController:FindVC];
    
    FindNav.tabBarItem.title = @"百科";
    
#pragma mark - JMRadio
    RadioViewController * JMVC = [[RadioViewController alloc] init];
    
    UINavigationController * JMNav = [[UINavigationController alloc] initWithRootViewController:JMVC];
    
    JMNav.tabBarItem.title = @"电台";

#pragma mark - Mine
    XLHMineViewController * mine = [[XLHMineViewController alloc] init];
    
    UINavigationController * mineNav = [[UINavigationController alloc] initWithRootViewController:mine];
    
    mineNav.tabBarItem.title = @"我的";
    
    
    
#pragma mark - tabbarController
    UITabBarController * tabbar = [[UITabBarController alloc] init];
    /** Controllers*/
    NSMutableArray * array = [NSMutableArray arrayWithObjects: SpecialNav, FindNav, JMNav, mineNav, nil];
    
    tabbar.viewControllers = array;

    
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
