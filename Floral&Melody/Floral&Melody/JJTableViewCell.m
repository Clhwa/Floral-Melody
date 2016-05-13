//
//  JJTableViewCell.m
//  Floral&Melody
//
//  Created by lanou on 16/5/12.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "JJTableViewCell.h"

@implementation JJTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        
        self.subTitle = [[UILabel alloc] init];
        [self.contentView addSubview:self.subTitle];
        
                
        self.imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageV];
        
        
        
    }
    return self;
    
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageV.frame = CGRectMake(0, 0, 80, 80);
   
    self.titleLabel.frame = CGRectMake(85, 10, self.contentView.bounds.size.width-85-20, 30);
    self.subTitle.frame = CGRectMake(85, 40, self.contentView.bounds.size.width-85-20, 20);
    
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    
    
    self.subTitle.textColor = [UIColor lightGrayColor];
    self.subTitle.font =[UIFont systemFontOfSize:12];
        
   
    
    
    
}

- (void)awakeFromNib {
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
