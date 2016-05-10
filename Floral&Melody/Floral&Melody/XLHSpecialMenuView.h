//
//  XLHSpecialMenuView.h
//  Floral&Melody
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 西兰花. All rights reserved.
//

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//设置颜色RGB
#define COLOR(RED, GRAY, BLUE, ALPHA) [UIColor colorWithRed:RED/255.0 green:GRAY/255.0 blue:BLUE/255.0 alpha:ALPHA]

#import "XLHBaseView.h"

#import "XLHMenuTableViewCell.h"


@interface XLHSpecialMenuView : XLHBaseView



- (instancetype)initWithFrame:(CGRect)frame titleItems:(NSArray *)titleItems;

+ (instancetype)XLHSpecialMenuViewWithFrame:(CGRect)frame titleItems:(NSArray *)titleItems;
@end
