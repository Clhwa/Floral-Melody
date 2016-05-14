//
//  XLHVideoPlayer.m
//  XMG播放视频
//
//  Created by lanou on 16/5/11.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHVideoPlayer.h"

@implementation XLHVideoPlayer
/** 创建播放器*/
+ (instancetype)videoPlayer
{
    static XLHVideoPlayer * VideoPlayer = nil;
    if ( !VideoPlayer) {
        VideoPlayer = [[XLHVideoPlayer alloc] init];
    }
    return VideoPlayer;
}

- (instancetype)init
{
    if (self = [super init]) {
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
        
        _player = [AVPlayer new];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        
        [_imageView.layer addSublayer:_playerLayer];
        
        _toolView = [UIView new];
        [_toolView setAlpha:0];
        [_imageView addSubview:_toolView];
        
        _WorkView = [UIView new];
        [_WorkView setAlpha:0];
        [_imageView addSubview:_WorkView];
        
        _share = [UIButton buttonWithType:UIButtonTypeCustom];
        [_WorkView addSubview:_share];
        
        _collect = [UIButton buttonWithType:UIButtonTypeCustom];
        [_WorkView addSubview:_collect];
        
        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_WorkView addSubview:_cancel];
        
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toolView addSubview:_playOrPauseBtn];
        
        _progressSlider = [UISlider new];
        [_toolView addSubview:_progressSlider];
        
        _timeLabel = [UILabel new];
        [_toolView addSubview:_timeLabel];
        
        _ScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toolView addSubview:_ScreenButton];
        
        self.isShowToolView = NO;
        self.playOrPauseBtn.selected = YES;
        
        [self removeProgressTimer];
        [self addProgressTimer];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];

    }
    return self;
}

- (void)layoutSubviews
{
    [_imageView setFrame:self.bounds];
    [_imageView setBackgroundColor:[UIColor whiteColor]];
    [_imageView setUserInteractionEnabled:YES];
    
    [_toolView setFrame:CGRectMake(0, _imageView.frame.size.height - 40 , _imageView.frame.size.width, 40 )];
    [_toolView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
    [_toolView setUserInteractionEnabled:YES];
    
    [_playOrPauseBtn setFrame:CGRectMake(0, 0, _toolView.frame.size.width * 0.12, _toolView.frame.size.height)];
    [_playOrPauseBtn setBackgroundColor:[UIColor clearColor]];
    [_playOrPauseBtn addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [_playOrPauseBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    [_playOrPauseBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateSelected];
    
    
    [_progressSlider setFrame:CGRectMake(_toolView.frame.size.width * 0.12, 0, _toolView.frame.size.width * 0.55 , _toolView.frame.size.height)];
    [_progressSlider setBackgroundColor:[UIColor clearColor]];
    [_progressSlider setMaximumValue:1.f];
    [_progressSlider setMinimumValue:0.f];
    [_progressSlider addTarget:self action:@selector(slider) forControlEvents:UIControlEventTouchUpInside];
    [_progressSlider addTarget:self action:@selector(startSlider) forControlEvents:UIControlEventTouchDown];
    [_progressSlider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
    [_progressSlider setMinimumTrackTintColor:[UIColor whiteColor]];
    [_progressSlider setMaximumTrackTintColor:COLOR(150, 150, 150, 0.7)];
    [_progressSlider setThumbImage:[UIImage imageNamed:@"进度"] forState:UIControlStateNormal];
    
    [_timeLabel setFrame:CGRectMake(_toolView.frame.size.width * 0.67, 0, _toolView.frame.size.width * 0.21, _toolView.frame.size.height)];
    [_timeLabel setBackgroundColor:[UIColor clearColor]];
    [_timeLabel setFont:[UIFont systemFontOfSize:13]];
    [_timeLabel setTextAlignment:1];
    [_timeLabel setTextColor:[UIColor whiteColor]];
    
    
    [_ScreenButton setFrame:CGRectMake(_toolView.frame.size.width * 0.88, 0, _toolView.frame.size.width * 0.12, _toolView.frame.size.height)];
    [_ScreenButton setBackgroundColor:[UIColor clearColor]];
    [_ScreenButton addTarget:self action:@selector(switchOrientation:) forControlEvents:UIControlEventTouchUpInside];
    [_ScreenButton setImage:[UIImage imageNamed:@"全屏"] forState:UIControlStateNormal];
    [_playerLayer setFrame:self.bounds];
    
    [_WorkView setFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    [_WorkView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
    [_WorkView setUserInteractionEnabled:YES];
    
    [_cancel setFrame:CGRectMake(0, 0, _WorkView.frame.size.width * 0.12, _WorkView.frame.size.height)];
    [_cancel setBackgroundColor:[UIColor clearColor]];
    [_cancel setImage:[UIImage imageNamed:@"取消"] forState:UIControlStateNormal];
    [_cancel addTarget:self action:@selector(cancelPlayer) forControlEvents:UIControlEventTouchUpInside];
    
    [_share setFrame:CGRectMake(_WorkView.frame.size.width * 0.76, 0, _WorkView.frame.size.width * 0.12, _WorkView.frame.size.height)];
    [_share setBackgroundColor:[UIColor clearColor]];
    [_share setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    
    [_collect setFrame:CGRectMake(_WorkView.frame.size.width * 0.88, 0, _WorkView.frame.size.width * 0.12, _WorkView.frame.size.height)];
    [_collect setBackgroundColor:[UIColor clearColor]];
    [_collect setImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
    [_collect setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateSelected];
    [_collect addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - 设置播放的视频
/** 设置播放的Item*/
- (void)setPlayerItem:(AVPlayerItem *)playerItem
{
    _playerItem = playerItem;
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self.player play];
}

/** 设置是否显示工具VIew*/
- (void)tapAction:(UIGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.5f animations:^{
        if (self.isShowToolView) {
            self.toolView.alpha = 0.f;
            self.WorkView.alpha = 0.f;
            self.isShowToolView = NO;
        } else {
            self.toolView.alpha = 1.f;
            self.WorkView.alpha = 1.f;
            self.isShowToolView = YES;
        }
    }];
}

/** 开始暂停按钮的方法*/
- (void)playOrPause:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.player play];
        
        [self addProgressTimer];
    } else {
        [self.player pause];
        
        [self removeProgressTimer];
    }
}

/** 全屏按钮的方法*/
- (void)switchOrientation:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(videoPlayerSwitchOrientation:)]) {
        [self.delegate videoPlayerSwitchOrientation:sender.selected];
    }
}

/** slider点击方法*/
- (void)slider
{
    [self addProgressTimer];
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    
    // 设置当前播放时间
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    [self.player play];
}

/** slider按下的方法*/
- (void)startSlider
{
    [self removeProgressTimer];
}

/** slider变化时的方法*/
- (void)sliderValueChange
{
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    self.timeLabel.text = [self stringWithCurrentTime:currentTime duration:duration];
    _playOrPauseBtn.selected = YES;
}

/** 取消播放的方法*/
- (void)cancelPlayer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeVideoPlayer" object:nil];
}

/** 点击收藏按钮*/
- (void)collectAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
}
#pragma mark - 定时器操作
/** 添加定时器*/
 - (void)addProgressTimer
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}
/** 移除定时器*/
- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}
/** 定时器方法*/
- (void)updateProgressInfo
{
    /** 更新时间*/
    [self.timeLabel setText:[self timeString]];
    /** 设置进度条的value*/
    self.progressSlider.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
}


/** 获取当前播放时间*/
- (NSString *)timeString
{
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    
    return [self stringWithCurrentTime:currentTime duration:duration];
}

/** 处理当前播放时间*/
- (NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    NSInteger dMin = duration / 60;
    NSInteger dSec = (NSInteger)duration % 60;
    
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", dMin, dSec];
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", cMin, cSec];
    
    return [NSString stringWithFormat:@"%@/%@", currentString, durationString];
}
@end
