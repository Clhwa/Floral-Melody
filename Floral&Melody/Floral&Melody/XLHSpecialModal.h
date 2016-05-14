//
//  XLHSpecialModal.h
//  Floral&Melody
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLHSpecialModal : NSObject

/** 图片地址 **/
@property (nonatomic, strong)NSString * Image;

/** 作者名字 **/
@property (nonatomic, strong)NSString * userName;

/** 作者标签 **/
@property (nonatomic, strong)NSString * identifier;

/** 作者头像 **/
@property (nonatomic, strong)NSString * userIcon;

/** type **/
@property (nonatomic, strong)NSString * type;

/** title **/
@property (nonatomic, strong)NSString * title;

/** content **/
@property (nonatomic, strong)NSString * content;

/** reader **/
@property (nonatomic, assign)NSInteger reader;

//mp4视频
@property(nonatomic,strong)NSString *videoUrl;

/** time **/
@property (nonatomic, strong)NSString * time;

/** pageUrl **/
@property (nonatomic, strong)NSString * pageUrl;

- (NSString *)getType:(NSString *)type;

- (NSString *)getTime:(NSString *)time;
@end
