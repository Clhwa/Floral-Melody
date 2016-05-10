//
//  XLHMenuTableViewCell.m
//  Floral&Melody
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHMenuTableViewCell.h"

@implementation XLHMenuTableViewCell



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = 1;
        _titleLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:15];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_titleLabel setFrame:CGRectMake(0, 0, 90, 37.5)];
    _titleLabel.layer.masksToBounds = YES;
    _titleLabel.layer.cornerRadius = 10;
}
@end
