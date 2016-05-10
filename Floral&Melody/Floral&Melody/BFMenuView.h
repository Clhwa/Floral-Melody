//
//  BFView.h
//  矩形
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 BF. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XLHSpecialMenuView.h"

@interface BFMenuView : UIView
-(instancetype)initWithFrame:(CGRect)frame withRadius:(CGFloat)r withTriangleLenth:(CGFloat)l withHeight:(CGFloat)h MenuWithTitleItems:(NSArray *)titleItems IconItems:(NSArray *)IconItems;




@end
