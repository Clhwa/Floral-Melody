//
//  VideoPlayerViewController.m
//  Floral&Melody
//
//  Created by lanou on 16/5/14.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "XLHFullViewController.h"

@interface VideoPlayerViewController ()<VideoPlayerDelegate>

{
    XLHVideoPlayer * playerView;
}
/** 播放器*/
@property (nonatomic, strong )AVPlayer * player;

@property (nonatomic , strong)XLHFullViewController * FullVC;
@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 9 / 16+64);
    
    playerView = [XLHVideoPlayer videoPlayer];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4"]];
    playerView.playerItem = item;
    playerView.delegate = self;
    [playerView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH * 9 / 16)];
    [self.view addSubview:playerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeVideoPlayer) name:@"removeVideoPlayer" object:nil];
    
}
-(void)removeVideoPlayer
{
    playerView.playerItem = nil;
    [playerView removeFromSuperview];
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    if (_FullVC) {
        [_FullVC.view removeFromSuperview];
    }
    NSLog(@"-->%p",playerView);
}
- (void)videoPlayerSwitchOrientation:(BOOL)isFull
{
    if (isFull) {
        
        [self presentViewController:self.FullVC
                           animated:NO completion:^{
                               playerView.frame = self.FullVC.view.bounds;
                               [self.FullVC.view addSubview:playerView];
                           }];
        
        
    } else {
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 9 / 16+64);
        [self.FullVC dismissViewControllerAnimated:NO completion:^{
                playerView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
        [self.view addSubview:playerView];
        
        }];
    }
    
}

#pragma mark - 懒加载代码
- (AVPlayer *)player
{
    if (_player == nil) {
        NSURL * url = [NSURL URLWithString:@"http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4"];
        AVPlayerItem * Item = [AVPlayerItem playerItemWithURL:url];
        _player = [AVPlayer playerWithPlayerItem:Item];
        AVPlayerLayer * layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        layer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
        [self.view.layer addSublayer:layer];
    }
    return _player;
}
- (XLHFullViewController *)FullVC
{
    if (_FullVC == nil) {
        _FullVC = [[XLHFullViewController alloc] init];
    }
    return _FullVC;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
