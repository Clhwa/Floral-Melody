//
//  WHC_NavigationController.h
//  WHC_NavigationControllerKit
//
//  Created by WHC on 15/4/14.
//  Copyright (c) 2015 WHC. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface WHC_NavigationController : UINavigationController
@property(nonatomic,strong)    UIPanGestureRecognizer           * panGesture;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (UIViewController *)popViewControllerAnimated:(BOOL)animated;

@end
