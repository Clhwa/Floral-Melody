//
//  BFCollectionReusableView.m
//  Flower&Melody
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 BF. All rights reserved.
//

#import "BFCollectionReusableView.h"

@implementation BFCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
    }
    return self;
}

@end
