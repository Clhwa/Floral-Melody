//
//  BFCollectionViewCell.m
//  Flower&Melody
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 BF. All rights reserved.
//

#import "BFCollectionViewCell.h"

@implementation BFCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(-15, self.frame.size.height-30, self.frame.size.width+30, 30)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:15];

        [self.contentView addSubview:_label];
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        [self.contentView addSubview:_imageV];
        _imageV.layer.cornerRadius = 10;
        _imageV.layer.masksToBounds = YES;
    }
    return self;
}

@end
