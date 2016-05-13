//
//  JJTableViewCell.h
//  Floral&Melody
//
//  Created by lanou on 16/5/12.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioListModel.h"
@interface JJTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLabel;//title
@property(nonatomic,strong)UILabel *subTitle;//子title
@property(nonatomic,strong)UIImageView *imageV;//图片

@property(nonatomic,strong)RadioListModel *listModel;
@property(nonatomic)NSInteger flag;

@end
