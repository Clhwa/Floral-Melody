//
//  PrefixHeader.h
//  Floral&Melody
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#ifndef PrefixHeader_h
#define PrefixHeader_h

//判断IOS7以上版本
#define ISIOS7PLUS ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
//判断iPhone型号大于5
#define ISIPHONE5PLUS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhone型号大于6
#define ISIPHONE6PLUS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//设置颜色RGB
#define COLOR(RED, GRAY, BLUE, ALPHA) [UIColor colorWithRed:RED/255.0 green:GRAY/255.0 blue:BLUE/255.0 alpha:ALPHA]

//专题接口
#define SpecialURL @"http://m.htxq.net/servlet/SysArticleServlet"


// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.

#endif /* PrefixHeader_h */
