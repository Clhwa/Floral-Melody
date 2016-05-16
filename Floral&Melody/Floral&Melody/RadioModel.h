//
//  RadioModel.h
//  Radio
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 Carman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioModel : NSObject
@property(nonatomic,assign)NSInteger count;//收听人数
@property(nonatomic,strong)NSString *coverimg;//页面图片
@property(nonatomic,strong)NSString *desc;//描述,介绍
@property(nonatomic,assign)BOOL isnew;//是否最新
@property(nonatomic,strong)NSString *title;//标题
@property(nonatomic,strong)NSString *radioid;//电台id,下一个网络请求的Body,可申请对应的电台列表
@property(nonatomic,strong)NSDictionary *dic;




@end
