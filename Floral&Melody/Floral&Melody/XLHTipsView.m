//
//  XLHTipsView.m
//  Floral&Melody
//
//  Created by lanou on 16/5/7.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHTipsView.h"

@implementation XLHTipsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [UILabel new];
        [_titleLabel setText:title];
        [_titleLabel setFrame:self.bounds];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextAlignment:1];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:14]];
        [self addSubview:_titleLabel];
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:3];
    }
    return self;
}

- (void)settitleText:(NSString *)text
{
    _titleLabel.text = text;
}
@end
