//
//  WarnLabel.m
//  Flower&Melody
//
//  Created by lanou on 16/5/6.
//  Copyright © 2016年 BF. All rights reserved.
//

#import "WarnLabel.h"


@implementation WarnLabel
//成功
+(WarnLabel *)creatWarnLabelWithY:(CGFloat)y withSuperView:(UIView *)view
{
    static WarnLabel *w = nil;
    if (!w) {
        w = [[WarnLabel alloc]init];
    }
    w.frame = CGRectMake(0, 0, 150, 40);
    w.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, y);
    [view addSubview:w];
    [w appearToDisappear];
    return w;
}


-(instancetype)init
{
    self = [super init];
    if (self) {
        self.alpha = 0.1;
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor blackColor];
        self.textColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
    }
    return self;
}
#pragma mark-动画出现消失
-(void)appearToDisappear
{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0.6;
    }completion:^(BOOL finished) {
        [self performSelector:@selector(disappear) withObject:nil afterDelay:0.5];
    }];
}
-(void)disappear
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.1;
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
