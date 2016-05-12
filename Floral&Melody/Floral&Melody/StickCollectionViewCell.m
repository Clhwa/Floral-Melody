//
//  StickCollectionViewCell.m
//  Flower&Melody
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 BF. All rights reserved.
//

#import "StickCollectionViewCell.h"

#import "LongPressGesture.h"
#define SPACE 10
#define HEIGHT self.frame.size.height
#define WIDTH self.frame.size.width


@implementation StickCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //cell
        self.layer.cornerRadius = 12.f;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1;
        self.backgroundColor = [UIColor whiteColor];
        
        _imageV = [FunctionImageView createImageViewWithFrame:CGRectZero withImage:nil];
        [self.contentView addSubview:_imageV];
        //菊花
        _act  = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_imageV addSubview:_act];
        //添加手势
        LongPressGesture *longPre = [LongPressGesture createLongPressGestureWithTitleArray:@[@"保存到相册"] withBlock:^(NSInteger index) {
            if (index == 0) {
                if (_imageV.image) {
                    UIImageWriteToSavedPhotosAlbum(_imageV.image, nil, nil, nil);//保存图片到相册
                }
            }
        }];
        [_imageV addGestureRecognizer:longPre];
        _imageV.userInteractionEnabled = YES;
        //imageV
        _imageV.backgroundColor = [UIColor whiteColor];
        _imageV.frame = CGRectMake(SPACE, SPACE, HEIGHT-2*SPACE, HEIGHT-2*SPACE-20);
        _imageV.layer.cornerRadius = 5;
        _imageV.layer.masksToBounds =YES;
        //菊花
        _act.center = CGPointMake(_imageV.frame.size.width/2, _imageV.frame.size.height/2);
        
        _titleLab = [[UILabel alloc]init];
        [self.contentView addSubview:_titleLab];
        _textLab = [[UILabel alloc]init];
        [self.contentView addSubview:_textLab];
        
        //label
        CGFloat w = _imageV.frame.size.width;
        _titleLab.frame = CGRectMake(w+SPACE*2, SPACE, WIDTH-w-SPACE*3, 20);
        _textLab.frame = CGRectMake(w+SPACE*2, _titleLab.frame.origin.y+_titleLab.frame.size.height+SPACE, WIDTH-w-SPACE*3, 60);
        _textLab.font = [UIFont systemFontOfSize:14];
        _textLab.numberOfLines = 3;
        _textLab.textColor = [UIColor darkGrayColor];
    }
    return self;
}




@end
