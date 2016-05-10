//
//  XLHSpecialMenuTableViewCell.m
//  Floral&Melody
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHSpecialMenuTableViewCell.h"

@implementation XLHSpecialMenuTableViewCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.textAlignment = 1;
        
        _titleLabel.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:15];
        
        _titleLabel.textColor = [UIColor blackColor];
        
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.frame = self.bounds;
}
@end
