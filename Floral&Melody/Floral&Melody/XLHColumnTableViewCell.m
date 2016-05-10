//
//  XLHColumnTableViewCell.m
//  Floral&Melody
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHColumnTableViewCell.h"

#define HEIGHT [UIScreen mainScreen].bounds.size.height * 0.6

@implementation XLHColumnTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

/** 初始化 **/
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = COLOR(231, 231, 231, 1);
        self.contentView.opaque = YES;
        _ImageView         =        [UIImageView new];
        _IconImageView     =        [UIImageView new];
        _VIPImageView      =        [UIImageView new];
        _readNumImageView  =        [UIImageView new];
        _timeImageView     =        [UIImageView new];
        _WhiteView         =        [UIView new];
        _lineView          =        [UIView new];
        _typeLabel         =        [UILabel new];
        _titleLabel        =        [UILabel new];
        _contentLabel      =        [UILabel new];
        _userNameLabel     =        [UILabel new];
        _timeLabel         =        [UILabel new];
        _identifierLabel   =        [UILabel new];
        _readerLabel       =        [UILabel new];
        [self.contentView addSubview:_WhiteView];
        [self.contentView addSubview:_lineView];
        [self.contentView addSubview:_ImageView];
        [self.contentView addSubview:_IconImageView];
        [self.contentView addSubview:_VIPImageView];
        [self.contentView addSubview:_readNumImageView];
        [self.contentView addSubview:_timeImageView];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_contentLabel];
        [self.contentView addSubview:_userNameLabel];
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:_identifierLabel];
        [self.contentView addSubview:_typeLabel];
        [self.contentView addSubview:_readerLabel];

    }
    return self;
}

/** layout **/
- (void)layoutSubviews
{
    /**白底*/
    [_WhiteView setFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, HEIGHT -5)];
    [_WhiteView setBackgroundColor:[UIColor whiteColor]];
    [_WhiteView setUserInteractionEnabled:YES];
    
    /**图片*/
    [_ImageView setFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, (HEIGHT - 5) / 2 - 5)];
//    [_ImageView setBackgroundColor:[UIColor yellowColor]];
    _ImageView.contentMode = UIViewContentModeScaleAspectFill;
    _ImageView.clipsToBounds = YES;
    [_ImageView setUserInteractionEnabled:YES];
    
    /**头像*/
    [_IconImageView setFrame:CGRectMake(SCREEN_WIDTH * 0.77, ((HEIGHT - 5) / 2) - HEIGHT * 0.03, SCREEN_WIDTH * 0.18, SCREEN_WIDTH * 0.18)];
    [_IconImageView setBackgroundColor:[UIColor lightGrayColor]];
    [_IconImageView setUserInteractionEnabled:YES];
    [_IconImageView.layer setMasksToBounds:YES];
    [_IconImageView.layer setCornerRadius:SCREEN_WIDTH * 0.09];
    
    /**VIP*/
    [_VIPImageView setFrame:CGRectMake(SCREEN_WIDTH * 0.89, ((HEIGHT - 5) / 2) + HEIGHT * 0.08, SCREEN_WIDTH * 0.08, SCREEN_WIDTH * 0.08)];
    _VIPImageView.backgroundColor = [UIColor whiteColor];
    [_VIPImageView setUserInteractionEnabled:YES];
    [_VIPImageView.layer setMasksToBounds:YES];
    [_VIPImageView.layer setCornerRadius:SCREEN_WIDTH * 0.05];
    _VIPImageView.image = [UIImage imageNamed:@"vip"];
    _VIPImageView.contentMode = UIViewContentModeScaleAspectFill;
    _VIPImageView.clipsToBounds = YES;
    
    /** userName*/
    [_userNameLabel setFrame:CGRectMake(SCREEN_WIDTH * 0.42, (HEIGHT - 5) / 2 + HEIGHT * 0.02, SCREEN_WIDTH * 0.32, HEIGHT * 0.05)];
//    [_userNameLabel setBackgroundColor:[UIColor greenColor]];
    [_userNameLabel setUserInteractionEnabled:YES];
    [_userNameLabel setTextAlignment:2];
    [_userNameLabel setTextColor:COLOR(132, 132, 132, 1)];
    [_userNameLabel setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:17]];

    
    /** reader*/
    [_identifierLabel setFrame:CGRectMake(SCREEN_WIDTH * 0.42, (HEIGHT - 5) / 2 + HEIGHT * 0.08, SCREEN_WIDTH * 0.32, HEIGHT * 0.04)];
//    [_identifierLabel setBackgroundColor:[UIColor blueColor]];
    [_identifierLabel setUserInteractionEnabled:YES];
    [_identifierLabel setTextAlignment:2];
    [_identifierLabel setTextColor:COLOR(169, 169, 169, 1)];
    [_identifierLabel setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:15]];

    
    /** type*/
    [_typeLabel setFrame:CGRectMake(SCREEN_WIDTH * 0.05, HEIGHT * 0.6, SCREEN_WIDTH * 0.32, HEIGHT * 0.06)];
    [_typeLabel setUserInteractionEnabled:YES];
    [_typeLabel setTextAlignment:0];
    [_typeLabel setTextColor:COLOR(225, 197, 127, 1)];
    [_typeLabel setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:15]];

    
    /** title */
    [_titleLabel setFrame:CGRectMake(SCREEN_WIDTH * 0.05, HEIGHT * 0.67, SCREEN_WIDTH * 0.8, HEIGHT * 0.06)];
//    [_titleLabel setBackgroundColor:[UIColor cyanColor]];
    [_titleLabel setUserInteractionEnabled:YES];
    [_titleLabel setTextAlignment:0];
    [_titleLabel setTextColor:COLOR(72, 72, 72, 1)];
    [_titleLabel setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:15]];

    
    /** content*/
    [_contentLabel setFrame:CGRectMake(SCREEN_WIDTH * 0.05, HEIGHT * 0.74, SCREEN_WIDTH * 0.78, HEIGHT * 0.1)];
//    [_contentLabel setBackgroundColor:[UIColor brownColor]];
    [_contentLabel setUserInteractionEnabled:YES];
    [_contentLabel setTextAlignment:0];
    [_contentLabel setTextColor:COLOR(160, 160, 160, 1)];
    [_contentLabel setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:14]];
    [_contentLabel setNumberOfLines:2];

    
    /** line*/
    [_lineView setFrame:CGRectMake(SCREEN_WIDTH * 0.05, HEIGHT * 0.86, SCREEN_WIDTH * 0.9, 1)];
    [_lineView setBackgroundColor:COLOR(219, 219, 219, 1)];
    
    /** readNumImageView*/
    [_readNumImageView setFrame:CGRectMake(SCREEN_WIDTH * 0.51, HEIGHT * 0.905, SCREEN_WIDTH * 0.06, SCREEN_WIDTH * 0.05)];
//    [_readNumImageView setBackgroundColor:[UIColor grayColor]];
    _readNumImageView.image = [UIImage imageNamed:@"浏览"];
    
    /** readerLabel*/
    [_readerLabel setFrame:CGRectMake(SCREEN_WIDTH * 0.6, HEIGHT * 0.905, SCREEN_WIDTH * 0.1, SCREEN_WIDTH * 0.07)];
//    [_readerLabel setBackgroundColor:[UIColor whiteColor]];
    [_readerLabel setTextAlignment:1];
    [_readerLabel setTextColor:COLOR(102, 102, 102, 1)];
    [_readerLabel setFont:[UIFont systemFontOfSize:12]];
    [_readerLabel sizeToFit];
    
    /** timeImageView*/
    [_timeImageView setFrame:CGRectMake(SCREEN_WIDTH * 0.72, HEIGHT * 0.905, SCREEN_WIDTH * 0.05, SCREEN_WIDTH * 0.05)];
    _timeImageView.image = [UIImage imageNamed:@"期刊"];
    
    /** TimeLabel*/
    [_timeLabel setFrame:CGRectMake(SCREEN_WIDTH * 0.8, HEIGHT * 0.905, SCREEN_WIDTH * 0.15, SCREEN_WIDTH * 0.07)];
//    [_timeLabel setBackgroundColor:[UIColor whiteColor]];
    [_timeLabel setTextAlignment:0];
    [_timeLabel setTextColor:COLOR(102, 102, 102, 1)];
    [_timeLabel setFont:[UIFont systemFontOfSize:12]];
    [_timeLabel sizeToFit];
}

- (void)drawRect:(CGRect)rect
{
    [(XLHColumnTableViewCell *)[self superview] drawRect:rect];
}

- (void)animation
{
    CATransform3D rotation;//3D旋转
    rotation = CATransform3DMakeTranslation(0 ,50 ,20);
    rotation = CATransform3DScale(rotation, 0.9, .9, 1);
    rotation.m34 = 1.0/ -600;
    self.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.layer.shadowOffset = CGSizeMake(10, 10);
    self.alpha = 0;
    self.layer.transform = rotation;
    [UIView beginAnimations:@"rotation" context:NULL];
    //旋转时间
    [UIView setAnimationDuration:0.6];
    self.layer.transform = CATransform3DIdentity;
    self.alpha = 1;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];

}

- (void)ror
{
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 1;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = 1;
    
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0,_IconImageView.frame.size.width, _IconImageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    [_IconImageView.image drawInRect:CGRectMake(1,1,_IconImageView.frame.size.width-2,_IconImageView.frame.size.height-2)];
    _IconImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [_IconImageView.layer addAnimation:animation forKey:nil];
}
@end
