//
//  MyCollectionViewCell.m
//  ui15瀑布流_1
//
//  Created by lanou on 16/2/29.
//  Copyright © 2016年 Carman. All rights reserved.
//

#import "JJCollectionViewCell.h"

@implementation JJCollectionViewCell
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageV = [[UIImageView alloc] init];
        self.title = [[UILabel alloc] init];
        self.content = [[UILabel alloc] init];
        [self.contentView addSubview:self.imageV];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:_content];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageV.backgroundColor = [UIColor orangeColor];
    self.imageV.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.width);
    
    _imageV.layer.cornerRadius = 5;
    _imageV.layer.masksToBounds = YES;
        
    
    UIView *vi = [[UIView alloc]init];
    vi.backgroundColor = [UIColor blackColor];
    [self addSubview:vi];
    vi.frame = CGRectMake(0, self.contentView.frame.size.width+12, 3, 16);
    self.title.frame = CGRectMake(6, self.contentView.frame.size.width+10, 100, 20);
    self.content.frame = CGRectMake(0, self.contentView.frame.size.width+30, 100, 20);
    
    self.title.font = [UIFont systemFontOfSize:16];

    self.content.textColor = [UIColor grayColor];
    self.content.font = [UIFont systemFontOfSize:14];
}

@end
