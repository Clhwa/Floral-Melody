//
//  XLHColumnTableViewCell.h
//  Floral&Melody
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLHColumnTableViewCell : UITableViewCell

/** whiteView **/
@property (nonatomic, strong)UIView * WhiteView;

/** LineView **/
@property (nonatomic, strong)UIView * lineView;

/** ImageView **/
@property (nonatomic, strong)UIImageView * ImageView;

/** IconImageView **/
@property (nonatomic, strong)UIImageView * IconImageView;

/** VIP **/
@property (nonatomic, strong)UIImageView * VIPImageView;

/** readNum **/
@property (nonatomic, strong)UIImageView * readNumImageView;

/** timeImageView **/
@property (nonatomic, strong)UIImageView * timeImageView;

/**Type **/
@property (nonatomic, strong)UILabel * typeLabel;

/**Title **/
@property (nonatomic, strong)UILabel * titleLabel;

/**content **/
@property (nonatomic, strong)UILabel * contentLabel;

/** userName **/
@property (nonatomic, strong)UILabel * userNameLabel;

/**identifier **/
@property (nonatomic, strong)UILabel * identifierLabel;

/**time **/
@property (nonatomic, strong)UILabel * timeLabel;

/**reader **/
@property (nonatomic, strong)UILabel * readerLabel;

- (void)animation;
- (void)ror;
@end
