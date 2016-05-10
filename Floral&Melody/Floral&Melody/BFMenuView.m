//
//  BFView.m
//  矩形
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 BF. All rights reserved.
//

#import "BFMenuView.h"
#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height
@implementation BFMenuView

- (instancetype)initWithFrame:(CGRect)frame withRadius:(CGFloat)r withTriangleLenth:(CGFloat)l withHeight:(CGFloat)h MenuWithTitleItems:(NSArray *)titleItems IconItems:(NSArray *)IconItems;{
    /*
     *  author @黎博峰
     *
     *  2016 - 05 - 04
     *
     *  All rights reserved.
     */
    self=  [super initWithFrame:frame];
    if (self) {
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        CAShapeLayer *layer= [CAShapeLayer layer];
        
        //三角形
        [path moveToPoint:CGPointMake(WIDTH/2-l/2, 0)];
        [path addLineToPoint:CGPointMake(WIDTH/2, -h)];
        [path addLineToPoint:CGPointMake(WIDTH/2+l/2, 0)];
        
        //矩形
        [path addLineToPoint:CGPointMake(WIDTH-r, 0)];
        [path addQuadCurveToPoint:CGPointMake(WIDTH, r) controlPoint:CGPointMake(WIDTH, 0)];
        [path addLineToPoint:CGPointMake(WIDTH, HEIGHT-r)];
        [path addQuadCurveToPoint:CGPointMake(WIDTH-r, HEIGHT) controlPoint:CGPointMake(WIDTH, HEIGHT)];
        [path addLineToPoint:CGPointMake(r, HEIGHT)];
        [path addQuadCurveToPoint:CGPointMake(0, HEIGHT-r) controlPoint:CGPointMake(0, HEIGHT)];
        [path addLineToPoint:CGPointMake(0, r)];
        [path addQuadCurveToPoint:CGPointMake(r, 0) controlPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(WIDTH/2-l/2, 0)];
        
        layer.path = path.CGPath;
        layer.fillColor = [UIColor whiteColor].CGColor;
        layer.strokeColor = [UIColor lightGrayColor].CGColor;
        
        //阴影
        layer.shadowColor = [UIColor grayColor].CGColor;
        layer.shadowOffset = CGSizeMake(- 5, 5);
        layer.shadowOpacity = 0.6;
//        layer.shouldRasterize = YES;
        [self.layer addSublayer:layer];
        
        [self addSubview:[XLHSpecialMenuView XLHSpecialMenuViewWithFrame:self.bounds titleItems:titleItems]];
        
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}




@end
