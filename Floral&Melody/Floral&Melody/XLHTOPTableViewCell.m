//
//  XLHTOPTableViewCell.m
//  Floral&Melody
//
//  Created by lanou on 16/5/6.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHTOPTableViewCell.h"

#define HEIGHT [UIScreen mainScreen].bounds.size.height * 0.205

@implementation XLHTOPTableViewCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(TOPType)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _shadowView = [UIView new];
        
        if (type == TOPONE) {
            _topLabel = [UILabel new];
            _upView = [UIView new];
            _downView = [UIView new];
            _titleLabel= [UILabel new];
            _engLabel = [UILabel new];
            _ImageView = [UIImageView new];
            _playButton = [UIButton new];
            
             [self.contentView addSubview:_topLabel];
             [self.contentView addSubview:_upView];
             [self.contentView addSubview:_downView];
             [self.contentView addSubview:_titleLabel];
             [self.contentView addSubview:_engLabel];
             [self.contentView addSubview:_ImageView];
            [self.contentView addSubview:_playButton];
            [_ImageView addSubview:_shadowView];
        }
        else
        {
            _OtherUpView = [UIView new];
            _OtherDownView = [UIView new];
            _OtherSquareView = [UIView new];
            _OtherEngOneLabel = [UILabel new];
            _OtherEngTwoLabel = [UILabel new];
            _OtherTitleLabel = [UILabel new];
            _OtherTopLabel = [UILabel new];
            _OtherImageView = [UIImageView new];
            _OtherWhiteView = [UIView new];
            
            [self.contentView addSubview:_OtherUpView];
            [self.contentView addSubview:_OtherDownView];
            [self.contentView addSubview:_OtherSquareView];
            [self.contentView addSubview:_OtherEngOneLabel];
            [self.contentView addSubview:_OtherEngTwoLabel];
            [self.contentView addSubview:_OtherTitleLabel];
            [self.contentView addSubview:_OtherTopLabel];
            [self.contentView addSubview:_OtherImageView];
            [self.contentView addSubview:_OtherWhiteView];
            [_OtherImageView addSubview:_shadowView];
        }
        
        
    }
    return self;
}

- (void)layoutSubviewsWithType:(TOPType)type
{
    [super layoutSubviews];
    
    self.backgroundColor = COLOR(241, 241, 241, 1);
    
    if (type == TOPONE) {
        /** 图片*/
        [_ImageView setFrame:CGRectMake(10, 3, SCREEN_WIDTH - 20, HEIGHT - 5)];
        [_ImageView setBackgroundColor:[UIColor lightGrayColor]];
        [_ImageView setUserInteractionEnabled:YES];
        _ImageView.contentMode = UIViewContentModeScaleAspectFill;
        _ImageView.clipsToBounds = YES;
        [self.contentView insertSubview:_ImageView atIndex:0];
        /** top文字*/
        [_topLabel setFrame:CGRectMake(10, HEIGHT * 0.09, SCREEN_WIDTH - 20, HEIGHT * 0.2)];
        [_topLabel setUserInteractionEnabled:YES];
        [_topLabel setTextAlignment:1];
        [_topLabel setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        [_topLabel setText:@"TOP X"];
        [_topLabel setTextColor:[UIColor whiteColor]];
        /** 上线*/
        [_upView setFrame:CGRectMake(SCREEN_WIDTH * 0.3, HEIGHT * 0.27 + 5, SCREEN_WIDTH * 0.4, 1.5)];
        [_upView setBackgroundColor:[UIColor whiteColor]];
        /** 标题*/
        [_titleLabel setFrame:CGRectMake(10, HEIGHT * 0.27 + 9, SCREEN_WIDTH - 20, HEIGHT * 0.4)];
        [_titleLabel setText:@"那些花儿的\"壁纸\" "];
        [_titleLabel setTextAlignment:1];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:16]];
        /** 下线*/
        [_downView setFrame:CGRectMake(SCREEN_WIDTH * 0.3, HEIGHT * 0.67 + 10, SCREEN_WIDTH * 0.4, 1.5)];
        [_downView setBackgroundColor:[UIColor whiteColor]];
        /** 英文文字标注*/
        [_engLabel setFrame:CGRectMake(10, HEIGHT * 0.67 + 14, SCREEN_WIDTH - 20, HEIGHT * 0.2)];
        [_engLabel setTextAlignment:1];
        [_engLabel setText:@"FLORAL&MELODY"];
        [_engLabel setTextColor:[UIColor whiteColor]];
        [_engLabel setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        
        [_shadowView setFrame:_ImageView.bounds];
        [_shadowView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
        
//        [_playButton setHidden:YES];
//        [_playButton setFrame:CGRectMake(0, 0, 60, 60)];
//        [_playButton setBackgroundColor:[UIColor clearColor]];
//        [_playButton setCenter:self.contentView.center];
//        [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
//        [_playButton setAlpha:0.6];
    }
    else
    {
        /** 白底*/
        [_OtherWhiteView setFrame:CGRectMake(10, 3, SCREEN_WIDTH - 10, HEIGHT - 3)];
        [_OtherWhiteView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView insertSubview:_OtherWhiteView atIndex:0];
        
        /** 图片*/
        [_OtherImageView setFrame:CGRectMake(10, 3, SCREEN_WIDTH * 0.4, HEIGHT - 3)];
        [_OtherImageView setBackgroundColor:[UIColor grayColor]];
        [_OtherImageView setUserInteractionEnabled:YES];
        _OtherImageView.contentMode = UIViewContentModeScaleAspectFill;
        _OtherImageView.clipsToBounds = YES;
        /** 方块*/
        [_OtherSquareView setFrame:CGRectMake(SCREEN_WIDTH * 0.575, 10, SCREEN_WIDTH * 0.3, HEIGHT * 0.5)];
        [_OtherSquareView setBackgroundColor:[UIColor whiteColor]];
        [_OtherSquareView.layer setBorderColor:COLOR(136, 136, 136, 1).CGColor];
        [_OtherSquareView.layer setBorderWidth:1];
        
        /** 英文*/
        [_OtherEngOneLabel setFrame:CGRectMake(SCREEN_WIDTH * 0.575 + 1, 12, SCREEN_WIDTH * 0.3 - 2, HEIGHT * 0.1)];
        [_OtherEngOneLabel setText:@"FLORAL"];
        [_OtherEngOneLabel setTextAlignment:1];
        [_OtherEngOneLabel setTextColor:[UIColor grayColor]];
        [_OtherEngOneLabel setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:9]];
        /** 排名数字*/
        [_OtherTopLabel setFrame:CGRectMake(SCREEN_WIDTH * 0.575 + 1, HEIGHT * 0.19 + 2, SCREEN_WIDTH * 0.3 - 2, HEIGHT * 0.25)];
        [_OtherTopLabel setTextColor:[UIColor blackColor]];
        [_OtherTopLabel setText:@"4"];
        [_OtherTopLabel setTextAlignment:1];
        [_OtherTopLabel setFont:[UIFont fontWithName:@"CourierNewPSMT" size:34]];
        /** 下方英文*/
        [_OtherEngTwoLabel setFrame:CGRectMake(SCREEN_WIDTH * 0.575 + 1, HEIGHT * 0.45, SCREEN_WIDTH * 0.3 - 2, HEIGHT * 0.1)];
        [_OtherEngTwoLabel setText:@"MELODY"];
        [_OtherEngTwoLabel setTextAlignment:1];
        [_OtherEngTwoLabel setTextColor:[UIColor grayColor]];
        [_OtherEngTwoLabel setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:9]];
        /** 上线*/
        [_OtherUpView setFrame:CGRectMake(SCREEN_WIDTH * 0.575, HEIGHT * 0.65, SCREEN_WIDTH * 0.3, 1)];
        [_OtherUpView setBackgroundColor:COLOR(103, 103, 103, 1)];
        /** 标题*/
        [_OtherTitleLabel setFrame:CGRectMake(SCREEN_WIDTH * 0.575, HEIGHT * 0.68, SCREEN_WIDTH * 0.3, HEIGHT * 0.22)];
        [_OtherTitleLabel setTextAlignment:1];
        [_OtherTitleLabel setTextColor:COLOR(54, 54, 54, 1)];
        [_OtherTitleLabel setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:12]];
        [_OtherTitleLabel setText:@"庭中一婉香"];
        /** 下线*/
        [_OtherDownView setFrame:CGRectMake(SCREEN_WIDTH * 0.575, HEIGHT * 0.93, SCREEN_WIDTH * 0.3, 1)];
        [_OtherDownView setBackgroundColor:COLOR(103, 103, 103, 1)];
        [_shadowView setFrame:_OtherImageView.bounds];
        [_shadowView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
    }
    
}
@end
