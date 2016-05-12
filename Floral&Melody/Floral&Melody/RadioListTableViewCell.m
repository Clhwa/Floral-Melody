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
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    
    
    self.musicVisit.textColor = [UIColor lightGrayColor];
    self.musicVisit.font =[UIFont systemFontOfSize:12];
//    [self.saveButton setImage:[UIImage imageNamed:@"iconfont-xiazai"] forState:UIControlStateNormal];
    

     self.titleLabel.text = self.listModel.longTitle;
     [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.listModel.coverimg] placeholderImage:[UIImage imageNamed:@"meigui.jpg"]];
 
     self.musicVisit.text = [NSString stringWithFormat:@"%ld",self.listModel.musicVisit];
     self.bigImageV.image = [UIImage imageNamed:@"yin"];
    
    
}
-(void)nn
{
    NSLog(@"777777");
//    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(300, 0, 50, 50)];
//    vi.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:vi];
    
    NSString *cacherPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSLog(@"%@",cacherPath);
    NSString *file = [cacherPath stringByAppendingPathComponent:@"radio.mp3"];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.listModel.musicUrl]];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //将临时文件剪切或复制到path文件里面
        [manager moveItemAtPath:location.path toPath:file error:nil];
        NSLog(@"下载视频完成");
    }];
    [task resume];

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
