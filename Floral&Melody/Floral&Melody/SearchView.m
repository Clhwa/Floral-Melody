//
//  SearchView.m
//  Flower&Melody
//
//  Created by lanou on 16/5/7.
//  Copyright © 2016年 BF. All rights reserved.
//

#import "SearchView.h"
#define WIDTH self.bounds.size.width
#define HEIGHT self.bounds.size.height
#define TIME 0.4
#define BUTTON_WIDTH 50
#define BUTTON_Y 27
@interface SearchView ()<UITextFieldDelegate>
{
    id fromValue;
    id toValue;
}
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UIButton *leftButton;
@property(nonatomic,strong)CABasicAnimation *basicAnimation;
@property(nonatomic,assign)BOOL isAppear;
@property(nonatomic,copy)void(^mySearchBlock)(void);

@property(nonatomic,strong)UIButton *backgroundButton;
@end

@implementation SearchView

-(instancetype)initWithFrame:(CGRect)frame withSearchBlock:(searchBlock)block withSuperView:(UIView *)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        _mySearchBlock = block;
        

        self.clipsToBounds = YES;
        
        //左边
        [self addSubview:self.leftButton];
        
        [self addSubview:self.imageV];
        
        [self drawAnimationPath];
        
        [superView addSubview:self];
       
        _isAppear = YES;
    }
    return self;
}
#pragma makr-动画路径
-(void)drawAnimationPath
{
  
    CGFloat searchButtonWidth = _leftButton.frame.size.width;
    CGFloat searchButtonHeight = _leftButton.frame.size.height;

    CGFloat arcCenterY = searchButtonHeight * 0.5;

    
    
    //动画路径设置(从一个小layer到另一个大layer)
    //设置动画前大小
    CAShapeLayer * shaperLayer = [CAShapeLayer layer];
    self.layer.mask = shaperLayer;
    

    CGFloat dValueButtonWH       = searchButtonWidth - searchButtonHeight/2;
    CGRect centerRect = CGRectMake(WIDTH-dValueButtonWH, BUTTON_Y, searchButtonHeight, searchButtonHeight);
    
    UIBezierPath *fromBezierPath = [UIBezierPath bezierPath];
    [fromBezierPath moveToPoint:CGPointMake(WIDTH-(0), BUTTON_Y)];
    [fromBezierPath addLineToPoint:CGPointMake(WIDTH-(BUTTON_WIDTH-arcCenterY), BUTTON_Y)];
    [fromBezierPath addArcWithCenter:CGPointMake(WIDTH-(BUTTON_WIDTH-arcCenterY) , arcCenterY+BUTTON_Y) radius:arcCenterY startAngle: 0 endAngle: M_PI_2 clockwise:NO];//clockwise(YES)顺时(NO)逆时方向
    [fromBezierPath addLineToPoint:CGPointMake(WIDTH-(0), searchButtonHeight+BUTTON_Y)];
    
    
    //设置动画后大小
    CGFloat radiusWidth = [UIScreen mainScreen].bounds.size.width - dValueButtonWH;
    CGFloat radiusHeight = _leftButton.frame.origin.y + searchButtonHeight/2;
    CGFloat radius = sqrt(radiusWidth * radiusWidth + radiusHeight * radiusWidth);
    UIBezierPath *toBezierPath   = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(centerRect, -radius, -radius)];
    
    shaperLayer.path          = fromBezierPath.CGPath;//开始先隐藏
    
    //记录参数
    fromValue = (__bridge id _Nullable)(fromBezierPath.CGPath);
    toValue = (__bridge id _Nullable)(toBezierPath.CGPath);
    
}
#pragma mark-动画出现
-(void)appearOrNot
{
    //判断是否已添加tf
    if (![self.subviews containsObject:self.tf]) {
        [self insertSubview:self.tf belowSubview:_imageV];
    }

    
    if (_isAppear) {
        self.basicAnimation.fromValue = fromValue;
        _basicAnimation.toValue = toValue;
        _tf.enabled = YES;
 
        [_tf becomeFirstResponder];
        [self backgroundAppearAnimation];
        
    }else{
       self.basicAnimation.toValue = fromValue;
        _basicAnimation.fromValue = toValue;
        _tf.enabled = NO;

        _tf.text = nil;
        [self backgroundDisappearAnimation];
      
    }
    [self.layer.mask addAnimation:_basicAnimation forKey:@"path"];
    _isAppear = !_isAppear;
    _leftButton.selected = !_leftButton.selected;
}

#pragma makr-背景按钮动画
-(void)backgroundAppearAnimation
{
    [self.superview addSubview:self.backgroundButton];
    [UIView animateWithDuration:TIME animations:^{
        self.backgroundButton.alpha = 0.8;
        _imageV.transform = CGAffineTransformMakeTranslation(-_imageV.frame.origin.x+5, 0);
    }];
}
-(void)backgroundDisappearAnimation
{
    [UIView animateWithDuration:TIME animations:^{
        self.backgroundButton.alpha = 0.1;
        _imageV.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.backgroundButton removeFromSuperview];
    }];
}


#pragma makr-协议
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _mySearchBlock();
    return YES;
}
#pragma makr-懒加载

-(UIImageView *)imageV
{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-_leftButton.frame.size.width+10, 22-18/2+20, 18, 18)];
        _imageV.image = [UIImage imageNamed:@"搜索3"];
    }
    return _imageV;
}
-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-(BUTTON_WIDTH), BUTTON_Y, BUTTON_WIDTH, HEIGHT-34)];//开始
//        _leftButton.backgroundColor = [UIColor blueColor];
        [_leftButton setTitle:@"取消" forState:UIControlStateSelected];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_leftButton addTarget:self action:@selector(appearOrNot) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
-(UIButton *)backgroundButton
{
    if (!_backgroundButton) {
        _backgroundButton = [[UIButton alloc]initWithFrame:CGRectMake(0, HEIGHT, WIDTH, [UIScreen mainScreen].bounds.size.height-HEIGHT)];
        _backgroundButton.backgroundColor = [UIColor blackColor];
        _backgroundButton.alpha = 0.8;
        [_backgroundButton addTarget:self action:@selector(appearOrNot) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundButton;
}
-(CABasicAnimation *)basicAnimation
{
    if (!_basicAnimation) {
        _basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        _basicAnimation.duration          = TIME;
        //以下两行同时设置才能保持移动后的位置状态不变
        _basicAnimation.fillMode=kCAFillModeForwards;
        _basicAnimation.removedOnCompletion = NO;
    }
    return _basicAnimation;
}
-(UITextField *)tf
{
    if (!_tf) {
        _tf = [[UITextField alloc]initWithFrame:CGRectMake(_imageV.frame.size.width+10, BUTTON_Y, WIDTH-(_imageV.frame.size.width+10)-BUTTON_WIDTH, HEIGHT-34)];
        _tf.layer.cornerRadius = 8;
        _tf.layer.masksToBounds = YES;
        _tf.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _tf.textColor = [UIColor whiteColor];
        _tf.layer.borderWidth = 1;
        _tf.returnKeyType = UIReturnKeySearch;
        _tf.clearButtonMode = UITextFieldViewModeAlways;
        _tf.backgroundColor = [UIColor whiteColor];
        _tf.placeholder = @"请输入你要搜索的植物";
        _tf.delegate = self;
    }
    return _tf;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
