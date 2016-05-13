//
//  RadioListTableViewCell.m
//  Radio
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 Carman. All rights reserved.
//

#import "RadioListTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation RadioListTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        
        self.musicVisit = [[UILabel alloc] init];
        [self.contentView addSubview:self.musicVisit];
        
//        self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.contentView addSubview:self.saveButton];
//        [self.saveButton addTarget: self action:@selector(nn) forControlEvents:UIControlEventTouchDown];
        
        self.imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageV];
        
        self.bigImageV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.bigImageV];
        
        self.rightimageV = [[UIImageView alloc] init];
        [self.contentView addSubview:_rightimageV];
        
    }
    return self;


}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageV.frame = CGRectMake(0, 0, 80, 80);
    self.bigImageV.frame = CGRectMake(85, 40, 20, 20);
    self.titleLabel.frame = CGRectMake(85, 10, self.contentView.bounds.size.width-85-60, 30);
    self.musicVisit.frame = CGRectMake(105, 40, 80, 20);
//    self.saveButton.frame = CGRectMake(self.contentView.bounds.size.width-60, (80-30)/2, 30, 30);
    _rightimageV.frame = CGRectMake(self.contentView.bounds.size.width-30, (80-30)/2, 20, 20);
    _rightimageV.image = [UIImage imageNamed:@"xiangyou"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    
    
    self.musicVisit.textColor = [UIColor lightGrayColor];
    self.musicVisit.font =[UIFont systemFontOfSize:12];
//    [self.saveButton setImage:[UIImage imageNamed:@"iconfont-xiazai"] forState:UIControlStateNormal];
    

     self.titleLabel.text = self.listModel.longTitle;
     [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.listModel.coverimg] placeholderImage:[UIImage imageNamed:@"meigui.jpg"]];
 
     self.musicVisit.text = [NSString stringWithFormat:@"%ld",self.listModel.musicVisit];
     self.bigImageV.image = [UIImage imageNamed:@"yin"];
    
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
