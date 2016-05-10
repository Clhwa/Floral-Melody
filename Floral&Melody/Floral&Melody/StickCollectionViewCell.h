//
//  StickCollectionViewCell.h
//  Flower&Melody
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 BF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListContent.h"
#import "FunctionImageView.h"
@interface StickCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIActivityIndicatorView *act;
@property(nonatomic,strong)FunctionImageView *imageV;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *textLab;



@end
