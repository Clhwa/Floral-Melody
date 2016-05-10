//
//  RadioListModel.h
//  Radio
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 Carman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioListModel : NSObject
@property(nonatomic,assign)NSInteger musicVisit;//收听人数
@property(nonatomic,strong)NSString *coverimg;//页面图片地址
@property(nonatomic,strong)NSString *musicUrl;//mp3的地址
@property(nonatomic,assign)BOOL isnew;//是否最新
@property(nonatomic,strong)NSString *title;//标题
@property(nonatomic,strong)NSString *titleid;//未知
@property(nonatomic,strong)NSString *webview_url;//文章网页链接;
@property(nonatomic,strong)NSString *uname;//作者名称
@property(nonatomic,strong)NSString *longTitle;
@end
