//
//  LongPressGesture.h
//  BF_功能型imageView
//
//  Created by lanou on 16/4/24.
//  Copyright © 2016年 BF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonBlock)(NSInteger index);

@interface LongPressGesture : UILongPressGestureRecognizer

+(LongPressGesture *)createLongPressGestureWithTitleArray:(NSArray *)titleArr withBlock:(buttonBlock)block;


@end
