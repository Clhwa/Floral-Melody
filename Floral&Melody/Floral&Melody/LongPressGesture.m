//
//  LongPressGesture.m
//  BF_功能型imageView
//
//  Created by lanou on 16/4/24.
//  Copyright © 2016年 BF. All rights reserved.
//

#import "LongPressGesture.h"
#define BUTTON_HEIGHT 45
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface LongPressGesture ()

@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)UIButton *blackView;
@property(nonatomic,strong)UIView *whiteView;
@property(nonatomic,copy)void(^myButtonBlock)(NSInteger index);
@end

@implementation LongPressGesture

+(LongPressGesture *)createLongPressGestureWithTitleArray:(NSArray *)titleArr withBlock:(buttonBlock)block
{
    LongPressGesture *l = [[LongPressGesture alloc]initWithTargetForImage];
    l.titleArr = titleArr;
    l.myButtonBlock = block;
    return l;
}

-(instancetype)initWithTargetForImage
{
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(longPress)];
        self.minimumPressDuration = 0.8;
    }
    return self;
}

-(void)longPress
{
    if (self.state == UIGestureRecognizerStateBegan) {
        UIWindow *window = [[UIApplication sharedApplication]keyWindow];
        [window addSubview:self.blackView];
        [window addSubview:self.whiteView];
        [self whiteViewAnimation];
    }
    
}
#pragma makr-弹出动画
-(void)whiteViewAnimation
{
    CABasicAnimation *baseSicAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    baseSicAnimation1.duration  = 0.2;
    baseSicAnimation1.repeatCount = 0;
    baseSicAnimation1.fromValue = [NSNumber numberWithInt:0.8];//倍数从0.5
    baseSicAnimation1.toValue = [NSNumber numberWithInt:1];//到2
    [_whiteView.layer addAnimation:baseSicAnimation1 forKey:@"scale"];
}
-(void)touchButton:(UIButton *)but
{
    _myButtonBlock(but.tag-100);
    
    [self removeViewAnimation];
}
#pragma mark-移除的动画
-(void)removeViewAnimation
{
    CABasicAnimation *baseSicAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    baseSicAnimation1.duration  = 0.21;
    baseSicAnimation1.repeatCount = 0;
    baseSicAnimation1.fromValue = [NSNumber numberWithInt:1];//倍数从0.5
    baseSicAnimation1.toValue = [NSNumber numberWithInt:0.8];//到2
    [_whiteView.layer addAnimation:baseSicAnimation1 forKey:@"scale"];
    
    [self performSelector:@selector(removeView) withObject:nil afterDelay:0.2];
}
#pragma makr-移除
-(void)removeView
{
    [_blackView removeFromSuperview];
    [_whiteView removeFromSuperview];
}
#pragma mark-懒加载
-(UIView *)whiteView
{
    if (!_whiteView) {
        _whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, BUTTON_HEIGHT*_titleArr.count)];
        for (int i = 0;i<_titleArr.count;i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, i*BUTTON_HEIGHT, 200, BUTTON_HEIGHT);
            [button setTitle:_titleArr[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.tag = 100+i;
            [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
            [_whiteView addSubview:button];
        }
        _whiteView.center = self.blackView.center;
        
    }
    return _whiteView;
}
-(UIButton *)blackView
{
    if (!_blackView) {
        _blackView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _blackView.backgroundColor = [UIColor blackColor];
        _blackView.alpha = 0.8;
        [_blackView addTarget:self action:@selector(touchBlackView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _blackView;
}
#pragma mark-背景按钮方法
-(void)touchBlackView:(UIButton *)but
{
    [self removeViewAnimation];
}

@end
