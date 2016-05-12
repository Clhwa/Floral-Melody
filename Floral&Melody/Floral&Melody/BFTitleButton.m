//
//  BFTitleButton.m
//  Floral&Melody
//
//  Created by lanou on 16/5/11.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "BFTitleButton.h"

@implementation BFTitleButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addTitleLabel) name:@"" object:nil];
    }
    return self;
}
-(void)addTitleLabel
{
    if (_myTitle) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.origin.y, self.frame.size.width, 15)];
        label.text = _myTitle;
        label.textColor = _myColor;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
