//
//  FunctionImageView.m
//  BF_功能型imageView
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 BF. All rights reserved.
//

#import "FunctionImageView.h"

@interface FunctionImageView ()<UIApplicationDelegate>
{
    UITapGestureRecognizer *tap;
}
@property(nonatomic,assign)BOOL isbig;
@property(nonatomic,strong)UIButton *backgroundView;
@property(nonatomic,assign)CGRect windowRect;
@property(nonatomic,strong)UITapGestureRecognizer *douleTap;
@property(nonatomic,assign)BOOL isdouleClickBig;
@property(nonatomic,assign)CGRect originalRect;
@property(nonatomic,strong)UIPanGestureRecognizer *pan;//拖拽手势
@property(nonatomic,strong)UIRotationGestureRecognizer *rotation;//旋转
@property(nonatomic,strong)UIPinchGestureRecognizer *pin;//缩放手势
@property(nonatomic,assign)CGRect selfRect;
@property(nonatomic,strong)UIView *mySuperView;
@end

@implementation FunctionImageView

+(FunctionImageView *)createImageViewWithFrame:(CGRect)frame withImage:(UIImage *)image
{
    FunctionImageView *fun = [[FunctionImageView alloc]initWithFrame:frame withImage:image];
    return fun;
}

-(instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = image;
        //添加点击手势
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
        //外加
//        self.layer.borderWidth = 4;
//        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
//       self.layer.shadowOffset = CGSizeMake(5, 5);
//        self.layer.shadowOpacity = 0.7;
//        self.layer.shouldRasterize = YES;
    }
    return self;
}
#pragma mark-点击
-(void)tapImage
{
    if (!_isbig) {
//        self.layer.borderWidth = 0;
//        self.layer.shadowOffset = CGSizeMake(0, 0);
        //展示放大图片
        [self getFrameToAddIntoWindow];
        
        _windowRect = self.frame;//记录展示前的大小
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
            self.center = self.backgroundView.center;
        }];//动画
        _originalRect = self.frame;//记录展示后的大小
        [self addGestureRecognizer:self.douleTap];//添加双击
        [self addGestureRecognizer:self.pan];//添加拖拽
        [self addGestureRecognizer:self.rotation];//添加旋转手势
        [self addGestureRecognizer:self.pin];//添加缩放手势
        _isbig = YES;
    }else{
        //退出
        [self touchBack];
    }
}
#pragma mark-把图片加到window上(根据具体调节)
-(void)getFrameToAddIntoWindow
{
    //1先获取cell的位置(加上偏移量)
    //2在获取在cell上的位置
    //3记得导航栏的64
    
    _mySuperView = self.superview;//记录加在哪个父类视图上
    _selfRect = self.frame;//点击前的位置大小
    
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    [window addSubview:self.backgroundView];
    
    //imageView->contentView->cell->collectionView->self.view+64
    
    UICollectionView *collect = (UICollectionView *)self.superview.superview.superview;
    UICollectionViewCell *cell = (UICollectionViewCell *)self.superview.superview;
   CGFloat frameY = cell.frame.origin.y-collect.contentOffset.y;
    CGFloat frameX = cell.frame.origin.x;
    CGRect rect = self.frame;
    rect.origin.x = self.frame.origin.x  + frameX;
    rect.origin.y = self.frame.origin.y + frameY+64;
    self.frame = rect;
    [window addSubview:self];
}
#pragma mark-双击
-(void)douleClick
{
    if(_isdouleClickBig){
        //双击变大
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformMakeScale(1.8, 1.8);
        }];
        _isdouleClickBig = NO;
    }else{
        //双击还原
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
        _isdouleClickBig = YES;
    }
}

#pragma mark-拖拽
-(void)panImage
{
    CGPoint point = [self.pan translationInView:self];
    self.transform = CGAffineTransformTranslate(self.transform, point.x, point.y);//这个方法中心点不会变化,导致下次无法居中,要用CGAffineTransformIdentity还原
    [self.pan setTranslation:CGPointZero inView:self];
    _isdouleClickBig = NO;
    NSLog(@"%f,%f",self.center.x,self.center.y);//拖拽时中心点发生变化
}
#pragma mark-旋转
-(void)rotationImage
{
    self.transform = CGAffineTransformRotate(self.transform, self.rotation.rotation);
    self.rotation.rotation = 0;
    _isdouleClickBig = NO;
}
#pragma mark-缩放
-(void)pinchImage
{
    self.transform = CGAffineTransformScale(self.transform, self.pin.scale, self.pin.scale);
    _pin.scale = 1;
    _isdouleClickBig = NO;
}
#pragma mark-懒加载
-(UIPinchGestureRecognizer *)pin
{
    if (!_pin) {
        _pin = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchImage)];
    }
    return _pin;
}
-(UIRotationGestureRecognizer *)rotation
{
    if (!_rotation) {
        _rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotationImage)];
    }
    return _rotation;
}
-(UIPanGestureRecognizer *)pan
{
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panImage)];
    }
    return _pan;
}
-(UITapGestureRecognizer *)douleTap
{
    if (!_douleTap) {
        _douleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(douleClick)];
        _douleTap.numberOfTapsRequired = 2;
        [tap requireGestureRecognizerToFail:self.douleTap];
        _isdouleClickBig = YES;
    }
    return _douleTap;
}


-(UIButton *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundView.backgroundColor = [UIColor blackColor];
        [_backgroundView addTarget:self action:@selector(touchBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundView;
}

#pragma mark-返回方法
-(void)touchBack
{
    //外加
//    self.layer.borderWidth = 4;
//    self.layer.shadowOffset = CGSizeMake(5, 5);
    
    [_backgroundView removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformIdentity;//还原
        self.frame = _windowRect;//还原展示前的位置
    }completion:^(BOOL finished) {
        self.frame = _selfRect;
        [_mySuperView addSubview:self];
    }];//动画
    [self removeGestureRecognizer:self.douleTap];//移除双击
    _isdouleClickBig = YES;
    [self removeGestureRecognizer:self.pan];//移除拖拽
    [self removeGestureRecognizer:self.rotation];//移除旋转手势
    [self removeGestureRecognizer:self.pin];//移除缩放手势
    _isbig = NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
