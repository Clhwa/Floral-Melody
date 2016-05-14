//
//  FirstTimeLoginView.h
//  UI_QQ2.0
//
//  Created by lanou on 16/3/24.
//  Copyright © 2016年 BF. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface FirstTimeLoginView : UIView<UIScrollViewDelegate>


-(id)initWithFrame:(CGRect)frame withImageArray:(NSArray *)imageArray;

@end
