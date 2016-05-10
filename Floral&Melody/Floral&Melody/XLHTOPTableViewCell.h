//
//  XLHTOPTableViewCell.h
//  Floral&Melody
//
//  Created by lanou on 16/5/6.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger,TOPType)
{
        TOPONE,
        TOPOTHER
};

@interface XLHTOPTableViewCell : UITableViewCell

#pragma mark - topOne

/** shadow **/
@property (nonatomic, strong)UIView * shadowView;

/**TOP! **/
@property (nonatomic, strong)UILabel * topLabel;

/** upView **/
@property (nonatomic, strong)UIView * upView;

/** downView **/
@property (nonatomic, strong)UIView * downView;

/**title **/
@property (nonatomic, strong)UILabel * titleLabel;

/**engLabel **/
@property (nonatomic, strong)UILabel * engLabel;

/** imageView **/
@property (nonatomic, strong)UIImageView * ImageView;

/** playButton*/
@property (nonatomic, strong)UIButton * playButton;


#pragma mark - topOther
/** ImageV **/
@property (nonatomic, strong)UIImageView * OtherImageView;

/** whiteView **/
@property (nonatomic, strong)UIView * OtherWhiteView;

/** upLine **/
@property (nonatomic, strong)UIView * OtherUpView;

/** downLine **/
@property (nonatomic, strong)UIView * OtherDownView;

/**OtherLabel **/
@property (nonatomic, strong)UILabel * OtherTitleLabel;

/** square **/
@property (nonatomic, strong)UIView * OtherSquareView;

/**OtherEngOneLabel **/
@property (nonatomic, strong)UILabel * OtherEngOneLabel;

/**OtherEngTwoLabel **/
@property (nonatomic, strong)UILabel * OtherEngTwoLabel;

/**OtherTopLabel **/
@property (nonatomic, strong)UILabel * OtherTopLabel;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(TOPType)type;

- (void)layoutSubviewsWithType:(TOPType)type;


@end
