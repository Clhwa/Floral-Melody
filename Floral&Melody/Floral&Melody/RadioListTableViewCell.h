//
//  RadioListTableViewCell.h
//  Radio
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 Carman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioListModel.h"

@interface RadioListTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *musicVisit;
//@property(nonatomic,strong)UIButton *saveButton;
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UIImageView *bigImageV;
@property(nonatomic,strong)RadioListModel *listModel;
@property(nonatomic)NSInteger flag;

@end
