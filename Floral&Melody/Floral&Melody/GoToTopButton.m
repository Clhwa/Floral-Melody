//
//  GoToTopButton.m
//  Flower&Melody
//
//  Created by lanou on 16/5/6.
//  Copyright © 2016年 BF. All rights reserved.
//

#import "GoToTopButton.h"

@interface GoToTopButton ()
@property(nonatomic,strong)UIScrollView *scrollView;
@end

@implementation GoToTopButton



-(instancetype)initWithFrame:(CGRect)frame withControlView:(UIScrollView *)scrollView
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(goToTop) forControlEvents:UIControlEventTouchUpInside];
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.7;
        self.layer.cornerRadius = self.frame.size.width/2;
        self.layer.masksToBounds = YES;
        UIImage *image = [UIImage imageNamed:@"置顶1"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self setBackgroundImage:image forState:UIControlStateNormal];
        _scrollView = scrollView;
    }
    return self;
}
-(void)goToTop
{
    [_scrollView setContentOffset:CGPointZero animated:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
