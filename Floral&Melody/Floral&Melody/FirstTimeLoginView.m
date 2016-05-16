//
//  FirstTimeLoginView.m
//  UI_QQ2.0
//
//  Created by lanou on 16/3/24.
//  Copyright © 2016年 BF. All rights reserved.
//

#import "FirstTimeLoginView.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface FirstTimeLoginView ()
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)UIScrollView *scroll;
@property(nonatomic,strong) UIPageControl *page;
@property(nonatomic,strong)NSArray *imageArray;//图片数组
@end

@implementation FirstTimeLoginView

#pragma -mark 第一种方法
//第二种方法是用viewConreoller代替,把引导图viewConreoller设置为根视图
-(id)initWithFrame:(CGRect)frame withImageArray:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _scroll = [[UIScrollView alloc]init];
        [self addSubview:_scroll];
        _page = [[UIPageControl alloc]init];
        [self addSubview:_page];
        _imageArray = imageArray;
        _button = [UIButton buttonWithType:UIButtonTypeCustom];

    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_imageArray.count == 0) {
        return;
    }
            //scrollerView滚动视图
            _scroll.frame = [UIScreen mainScreen].bounds;
            _scroll.contentSize = CGSizeMake(_scroll.frame.size.width*_imageArray.count, _scroll.frame.size.height);
            _scroll.pagingEnabled = YES;
            _scroll.showsHorizontalScrollIndicator = NO;//取消水平滚动条
            _scroll.bounces = NO;
            _scroll.delegate = self;
            for (int i = 0; i<_imageArray.count; i++) {
                UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(_scroll.frame.size.width*i, 0, _scroll.frame.size.width, _scroll.frame.size.height)];
                //填充
                imageV.contentMode =  UIViewContentModeScaleAspectFill;
                imageV.clipsToBounds = YES;
                [_scroll addSubview:imageV];
                imageV.image = _imageArray[i];
                if (i == _imageArray.count-1) {
                    [imageV addSubview:_button];
                    imageV.userInteractionEnabled = YES;
                }
            }
            
                        //分页
            _page.frame = CGRectMake(0, HEIGHT-60, WIDTH, 30);
            _page.numberOfPages = _imageArray.count;
            _page.currentPageIndicatorTintColor = [UIColor colorWithRed:29/255.0 green:138/255.0 blue:198/255.0 alpha:1];
            _page.pageIndicatorTintColor = [UIColor whiteColor];
            [_page addTarget:self action:@selector(touchPage:) forControlEvents:UIControlEventValueChanged];
            
            //按钮
    _button.frame = CGRectMake(0, HEIGHT*0.6, 120, 40);
    _button.center = CGPointMake(WIDTH/2, _button.center.y);
    
    [_button setTitle:@"进入应用" forState:UIControlStateNormal];
               _button.layer.cornerRadius = 7;
            _button.layer.masksToBounds = YES;
    [_button addTarget:self action:@selector(flagFirstLogin) forControlEvents:UIControlEventTouchUpInside];
    

 
}
-(void)flagFirstLogin
{
    [UIView animateWithDuration:0.3 animations:^{
        _button.transform = CGAffineTransformMakeTranslation(0, HEIGHT*0.2+40);
    }];
    [UIView animateWithDuration:2 animations:^{
        
        self.transform = CGAffineTransformMakeScale(1.6, 1.6);
        self.alpha = 0.1;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:@"有了" forKey:@"标记"];
}

//滚动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _page.currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
}
//分页
-(void)touchPage:(UIPageControl *)page
{
    [_scroll setContentOffset:CGPointMake(_scroll.frame.size.width*page.currentPage, 0) animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
