//
//  WarnEnableEmptyLabel.m
//  Flower&Melody
//
//  Created by lanou on 16/5/8.
//  Copyright © 2016年 BF. All rights reserved.
//

#import "WarnEnableEmptyLabel.h"
#define HEIGHT self.frame.size.height
#define WIDTH self.frame.size.width
#define TRI_HEIGHT 24
#define TRI_WIDTH 15
#define TRI_X 50
#define TRI_ANGLE 15
#define RADIUS 5
#define TIME 0.35

@interface WarnEnableEmptyLabel ()
@property(nonatomic,strong)NSString *myText;
@end

@implementation WarnEnableEmptyLabel

-(instancetype)initWithFrame:(CGRect)frame withSuperView:(UIView *)superView withText:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        //label
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:15];
//        self.backgroundColor = [UIColor lightGrayColor];

        
        //路径
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(RADIUS, 0)];
        [path addLineToPoint:CGPointMake(TRI_X, 0)];
        [path addLineToPoint:CGPointMake(TRI_X-TRI_ANGLE, -TRI_HEIGHT)];
        [path addLineToPoint:CGPointMake(TRI_X+TRI_WIDTH, 0)];
        [path addLineToPoint:CGPointMake(WIDTH-RADIUS, 0)];
        [path addQuadCurveToPoint:CGPointMake(WIDTH, RADIUS) controlPoint:CGPointMake(WIDTH, 0)];
        [path addLineToPoint:CGPointMake(WIDTH, HEIGHT-RADIUS)];
        [path addQuadCurveToPoint:CGPointMake(WIDTH-RADIUS, HEIGHT) controlPoint:CGPointMake(WIDTH, HEIGHT)];
        [path addLineToPoint:CGPointMake(RADIUS, HEIGHT)];
        [path addQuadCurveToPoint:CGPointMake(0, HEIGHT-RADIUS) controlPoint:CGPointMake(0, HEIGHT)];
        [path addLineToPoint:CGPointMake(0, RADIUS)];
        [path addQuadCurveToPoint:CGPointMake(RADIUS, 0) controlPoint:CGPointMake(0, 0)];
        
        CAShapeLayer *layer = [[CAShapeLayer alloc]init];
        layer.path = path.CGPath;//获取路径
        layer.fillColor = [UIColor whiteColor].CGColor;
        layer.strokeColor = [UIColor lightGrayColor].CGColor;
        
        //阴影
        layer.shadowColor = [UIColor blackColor].CGColor;
        layer.shadowOffset = CGSizeMake(2, 2);
        layer.shadowOpacity = 0.5;
        layer.shouldRasterize = YES;
       
        
        //路径动画
        CABasicAnimation *_basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        _basicAnimation.duration     = TIME;
        //以下两行同时设置才能保持移动后的位置状态不变
        _basicAnimation.fillMode = kCAFillModeForwards;
        _basicAnimation.removedOnCompletion = NO;
        
        //动画顺序
        UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:self.frame cornerRadius:5];
        _basicAnimation.fromValue = (__bridge id _Nullable)(path1.CGPath);
        _basicAnimation.toValue = (__bridge id _Nullable)(path.CGPath);
        
       //添加路径动画到layer
        [layer addAnimation:_basicAnimation forKey:@"path"];
        
        self.layer.mask = layer;//layer动画放在哪
        
        [self.layer addSublayer:layer];//添加硬性layer
        
        _myText = text;
        
        [superView addSubview:self];
        
        [self performSelector:@selector(setText) withObject:nil afterDelay:TIME];
    }
    return self;
}
-(void)setText
{
    self.text = _myText;
    [self performSelector:@selector(remove) withObject:nil afterDelay:0.5];
}
-(void)remove
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.2;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
