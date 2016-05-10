//
//  XLHArticleTableViewCell.m
//  Floral&Melody
//
//  Created by lanou on 16/5/10.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHArticleTableViewCell.h"

@implementation XLHArticleTableViewCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

   self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _ImageView = [UIImageView new];
        _articleView = [XLHArticleView new];
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_ImageView];
        [self.contentView addSubview:_articleView];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = COLOR(241, 241, 241, 1);
    
    [_ImageView setFrame:CGRectMake(5, 5, WIDTH - 10, HEIGHT - 5)];
    
    [_articleView setFrame:CGRectMake(WIDTH / 3.25, HEIGHT * 0.3, WIDTH/2.5, HEIGHT * 0.4)];
    
    [_articleView setBackgroundColor:[UIColor clearColor]];
    
    [_titleLabel setFrame:_articleView.frame];
    [_titleLabel setTextColor:[UIColor blackColor]];
    [_titleLabel setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:12]];
    [_titleLabel setNumberOfLines:2];
    [_titleLabel setTextAlignment:1];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
}

- (void)setTitleLabelText:(NSString *)titleLabelText
{
    
    if (titleLabelText.length >= 6) {
        NSInteger length = [titleLabelText length];
        
        NSInteger lengthCount = length / 2;
        
        NSMutableString * string = [titleLabelText mutableCopy];
        
        [string insertString:@"\n" atIndex:lengthCount];
        
        _titleLabel.text = string;
    }
    
}
@end
