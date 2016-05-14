//
//  XLHVideoPlayer.h
//  XMG播放视频
//
//  Created by lanou on 16/5/11.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//设置颜色RGB
#define COLOR(RED, GRAY, BLUE, ALPHA) [UIColor colorWithRed:RED/255.0 green:GRAY/255.0 blue:BLUE/255.0 alpha:ALPHA]

@protocol VideoPlayerDelegate <NSObject>
/** 判断是否执行横屏的方法*/
- (void)videoPlayerSwitchOrientation:(BOOL)isFull;

@end
@interface XLHVideoPlayer : UIView
/** 创建player*/
+ (instancetype)videoPlayer;

/** 代理*/
@property (nonatomic, strong)id<VideoPlayerDelegate>delegate;

/** player的Item*/
@property (nonatomic, strong)AVPlayerItem * playerItem;

/** 播放器*/
@property (nonatomic, strong)AVPlayer *player;

/** 播放器的layer*/
@property (nonatomic, strong)AVPlayerLayer * playerLayer;

/** 默认背景图*/
@property (strong, nonatomic)  UIImageView *imageView;

/** 工具View*/
@property (strong, nonatomic)  UIView *toolView;

/** 播放与暂停按钮*/
@property (strong, nonatomic)  UIButton *playOrPauseBtn;

/** 进度条*/
@property (strong, nonatomic)  UISlider *progressSlider;

/** 时间戳*/
@property (strong, nonatomic)  UILabel *timeLabel;

/** 记录是否显示了工具栏*/
@property (nonatomic, assign)BOOL isShowToolView;

/** 定时器*/
@property (nonatomic, strong)NSTimer * progressTimer;

/** 全屏按钮*/
@property (nonatomic, strong)UIButton * ScreenButton;

/** 上方工具栏*/
@property (nonatomic, strong)UIView * WorkView;

/** 分享 **/
@property (nonatomic, strong)UIButton * share;

/** 收藏 **/
@property (nonatomic, strong)UIButton * collect;

/** 取消按钮 **/
@property (nonatomic, strong)UIButton * cancel;

@end
