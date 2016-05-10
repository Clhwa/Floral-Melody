//
//  XLHArticleView.m
//  HTXQ - demo
//
//  Created by lanou on 16/5/9.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHArticleView.h"
#define HEIGHT self.frame.size.height
#define WIDTH self.frame.size.width
@implementation XLHArticleView


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextSetLineWidth(context, 1.5);  //线宽
    
    CGContextSetAllowsAntialiasing(context, true);
    
    CGContextSetRGBStrokeColor(context, 255.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0, 1.0);  //线的颜色
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, WIDTH / 4, HEIGHT);  //起点坐标
    CGContextAddLineToPoint(context, 0, HEIGHT);   //终点坐标
    
    CGContextMoveToPoint(context, 0, HEIGHT);  //起点坐标
    CGContextAddLineToPoint(context, 0, 0);   //终点坐标
    
    CGContextMoveToPoint(context, 0, 0);  //起点坐标
    CGContextAddLineToPoint(context, WIDTH, 0);   //终点坐标
    
    CGContextMoveToPoint(context, WIDTH, 0);  //起点坐标
    CGContextAddLineToPoint(context, WIDTH, HEIGHT);   //终点坐标
    
    CGContextMoveToPoint(context, WIDTH, HEIGHT);  //起点坐标
    CGContextAddLineToPoint(context, WIDTH * 0.75, HEIGHT);   //终点坐标
    
    CGContextStrokePath(context);
    
    [_squareView setFrame:CGRectMake(10, 5, WIDTH - 20, HEIGHT - 13)];
    [_squareView setBackgroundColor:[UIColor whiteColor]];
    [_squareView setAlpha:0.5];
    
    [_pointOne setFrame:CGRectMake(WIDTH * 0.25 + 5, HEIGHT - 2, 3, 3)];
    [_pointOne.layer setCornerRadius:1.5];
    [_pointOne.layer setMasksToBounds:YES];
    [_pointOne setBackgroundColor:[UIColor whiteColor]];
    
    [_pointTwo setFrame:CGRectMake(WIDTH * 0.75 - 8 , HEIGHT - 2, 3, 3)];
    [_pointTwo.layer setCornerRadius:1.5];
    [_pointTwo.layer setMasksToBounds:YES];
    [_pointTwo setBackgroundColor:[UIColor whiteColor]];
    
    [_engLabel setFrame:CGRectMake(WIDTH * 0.25 + 10, HEIGHT - 5, WIDTH * 0.4, 10)];
    [_engLabel setTextColor:[UIColor whiteColor]];
    [_engLabel setFont:[UIFont systemFontOfSize:9]];
    [_engLabel setTextAlignment:1];
    [_engLabel setText:@"花の旋律"];
    [_engLabel setBackgroundColor:[UIColor clearColor]];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _squareView = [UIView new];
        [self addSubview:_squareView];
        
        _pointOne = [UIView new];
        [self addSubview:_pointOne];
        
        _pointTwo = [UIView new];
        [self addSubview:_pointTwo];
        
        _engLabel = [UILabel new];
        [self addSubview:_engLabel];
    }
    return self;
}

@end
