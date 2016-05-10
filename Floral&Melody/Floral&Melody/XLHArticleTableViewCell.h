//
//  XLHArticleTableViewCell.h
//  Floral&Melody
//
//  Created by lanou on 16/5/10.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XLHArticleView.h"

@interface XLHArticleTableViewCell : UITableViewCell
/** backImage **/
@property (nonatomic, strong)UIImageView * ImageView;

/** articleView*/
@property (nonatomic, strong)XLHArticleView * articleView;

/**titleLabel **/
@property (nonatomic, strong)UILabel * titleLabel;

- (void)setTitleLabelText:(NSString * )titleLabelText;
@end
#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height