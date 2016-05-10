
//
//  JJPlayer.m
//  Radio
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 Carman. All rights reserved.
//

#import "JJPlayer.h"

@interface JJPlayer()
{
    BOOL _isPlaying;//标记是否正在播放
    BOOL _isPrepares;//标记播放是否准备完成
}
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)NSTimer *timer;

@end


@implementation JJPlayer

//音乐播放器的懒加载
-(AVPlayer *)player
{
    if (!_player)
    {
        self.player = [[AVPlayer alloc]init];
    }
    return  _player;
}
+(instancetype)sharedplayer
{
    static JJPlayer *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[JJPlayer alloc] init];
    });
    return player;

}

-(instancetype)init
{
   self = [super init];
    if (self) {
        //对象刚初始化的时候就注册通知
        //AVPlayerItemDidPlayToEndTimeNotification是一个系统自带的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;


}
-(void)play
{
    //把isPlaying的状态设置为播放的状态
    _isPlaying = YES;
    [self.player play];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(handleTimerAction:) userInfo:nil repeats:YES];
}
//会0.1秒实行一次
-(void)handleTimerAction:(NSTimer *)sender
{
    //判断代理是否存在，并且是否相应该方法
    if (self.delegate&&[self.delegate respondsToSelector:@selector(audioPlayer:didPlayingWithProgress:)])
    {
        //如果响应了，就让代理去执行这个方法（）
        //为什么要在这里写一个progress方法呢？
        //因为在该类的内部可以计算出来进度条，而正好在播放的视图控制器里面需要用进度条，那么我们就可以使用协议传值传递到播放的页面直接使用
        //该方法的具体实现要写在播放页面里面
        
        //CMTime. value/timescale = seconds(秒数)
        float progress = self.player.currentTime.value/self.player.currentTime.timescale;
        
        [self.delegate audioPlayer:self didPlayingWithProgress:progress];
    }
}

-(void)pause
{
    _isPlaying = NO;
    [self.player pause];
    //停止计时器的方法
    [self.timer invalidate];
    self.timer = nil;
}
-(void)stop
{
    //停止的时候要先暂停
    [self pause];
    [self.player seekToTime:CMTimeMake(0, self.player.currentTime.timescale)];
}
//拖动音乐条的方法
-(void)seekToTime:(float)time {
    //在拖动进度条的时候先暂停
    [self pause];
    //CMTimeMakeWithSeconds有两个参数，
    //第一个是拖动到哪里
    //第二个是总时间
    [self.player seekToTime:CMTimeMakeWithSeconds(time,self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
        //拖动结束后音乐播放器重新播放
        if (finished)
        {
            [self play];
        }
    }];
}
#pragma -mark判断当前音乐时候正在播放
-(BOOL)isPlaying
{
    return _isPlaying;
}
//根据url切换歌曲的
-(void)setPlayerWithAVPlayerItem:(AVPlayerItem *)AVPlayerItem;
{
//    //根据url创建一个歌曲的播放对象
//    AVPlayerItem *currentItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlString]];
    //用刚创建的一个新的播放对象，替换原来的播放对象
    [self.player replaceCurrentItemWithPlayerItem:AVPlayerItem];
    
}
#pragma 判断当前正在播放歌曲的url和给定的url是否一样
-(BOOL)isPlayingCurrentPlayerWithUrl:(NSString *)urlString
{
    //将url转变成字符串
    NSString * url=[(AVURLAsset *)self.player.currentItem.asset URL].absoluteString;
    BOOL isEqual = [url isEqualToString:urlString];
    return isEqual;
}
#pragma mark--播放完成调用该方法
-(void)handleEndTimeNotification:(NSNotification *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying:)]) {
        // [self.delegate audioPlayerDidFinishPlaying];
        [self.delegate audioPlayerDidFinishPlaying:nil];
        
    }
}





@end
