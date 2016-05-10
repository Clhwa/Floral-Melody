//
//  JJPlayer.h
//  Radio
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 Carman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class JJPlayer;

@protocol JJPlayerDeleger <NSObject>

@optional
//创建播放器和播放进度
-(void)audioPlayer:(JJPlayer *)player didPlayingWithProgress:(float)progress;
-(void)audioPlayerDidFinishPlaying:(JJPlayer *)player;


@end

@interface JJPlayer : NSObject<JJPlayerDeleger>
//设置代理
@property(nonatomic)id<JJPlayerDeleger> delegate;
+(instancetype)sharedplayer;
-(void)play;//播放
-(void)pause;//暂停
-(void)stop;//停止

//根据url设置播放器
-(void)setPlayerWithAVPlayerItem:(AVPlayerItem *)AVPlayerItem;
-(void)seekToTime:(float)time;//跳转到指定时间播放
-(BOOL)isPlaying;//判断当前时候正在播放
//-(BOOL)isPrepared;//是否准备完毕。
-(BOOL)isPlayingCurrentPlayerWithUrl:(NSString *)urlString;//判断是否正在播放指定的音乐


@end
