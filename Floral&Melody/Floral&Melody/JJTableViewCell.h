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
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *musicVisit;
@property(nonatomic,strong)UIImageView *imageV;

@property(nonatomic,strong)RadioListModel *listModel;
@property(nonatomic)NSInteger flag;

@end
