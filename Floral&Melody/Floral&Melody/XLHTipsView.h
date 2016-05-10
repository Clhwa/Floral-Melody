//
//  XLHTipsView.h
//  Floral&Melody
//
//  Created by lanou on 16/5/7.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLHTipsView : UIView

/**title **/
@property (nonatomic, strong)UILabel * titleLabel;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

- (void)settitleText:(NSString *)text;
@end
