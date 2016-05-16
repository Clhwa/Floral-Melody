//
//  VideoPlayerViewController.m
//  happysharing
//
//  Created by dengchongkang on 16/3/2.
//  Copyright © 2016年 jackTang. All rights reserved.
//

//横屏下的屏幕宽高
#define SCREEN_WIDTH1 [[UIScreen mainScreen]bounds].size.height
#define SCREEN_HEIGHT1 [[UIScreen mainScreen]bounds].size.width

#import "VideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoPlayerViewController ()

@property(nonatomic,strong) AVPlayer *player; //播放属性
@property(nonatomic,strong) AVPlayerItem *playerItem; //播放属性
@property(nonatomic,strong) UISlider *slider; //进度条
@property(nonatomic,strong) UIProgressView *progress; //缓冲条
@property(nonatomic,strong) UILabel *currenTimeLabel; //时间
@property(nonatomic,strong) UIView *background;  //背景
@property(nonatomic,strong) UIView *topView;  //顶部
@property(nonatomic,assign) CGPoint startPoint; //当前触摸的位置
@property(nonatomic,assign) CGFloat systemVolume; //系统音量
@property(nonatomic,strong) UISlider *VolumSlider; //音量进度条
@property(nonatomic,strong) UIActivityIndicatorView *activity; //系统菊花(活动指示器)

@property (nonatomic, strong) NSObject *endObesever;
@property (nonatomic, strong) NSTimer *timer;

@property(nonatomic)BOOL isSave;
@property(nonatomic,strong)UIButton *SaveBackbutton;
@end

@implementation VideoPlayerViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self judge];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self creatPlayer];
    
    [self creatBackViewAndTopView];
    
    [self creatActivityView];
    
    [self createProgress];
    
    [self createSlider];
    [self createCurrentTimeLabel];
    [self creatTimer];
    [self creatButton];
    
    [self creatbackButton];
    [self createTitle];
    [self createGesture];
    [self creatSaveButton];
    
    
}

#pragma mark - 横屏代码

//当前viewcontroller是否支持转屏
- (BOOL)shouldAutorotate{
    return NO;
}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if ([NSStringFromClass([[[window subviews]lastObject] class]) isEqualToString:@"UITransitionView"]) {
        return UIInterfaceOrientationMaskAll;
       
    }
    return UIInterfaceOrientationMaskPortrait;
}

//当前viewcontroller支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscape;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}

- (BOOL)prefersStatusBarHidden
{
    return YES; // 返回NO表示要显示，返回YES将hiden
}


#pragma mark -创建AVPlayer以及相关联的方法属性

//返回得到的当前的网络

-(void)creatPlayer
{

    
    self.playerItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:_model.videoUrl]];;
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH1, SCREEN_HEIGHT1);
    playerLayer.videoGravity = AVLayerVideoGravityResize;
    [self.view.layer addSublayer:playerLayer];
     [_player play];
    //Player播放完成后通知
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(self.playerItem)];

    _endObesever = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self dismissViewControllerAnimated:YES completion:NULL];

    }];
}
//KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        [self.progress setProgress:timeInterval / totalDuration animated:NO];
    }
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}




#pragma mark -创建背景view 以及顶部view
-(void)creatBackViewAndTopView
{
    
    self.background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH1, SCREEN_HEIGHT1)];
    [self.view addSubview:_background];
    _background.backgroundColor = [UIColor clearColor];
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH1, SCREEN_HEIGHT1 * 0.15)];
    _topView.backgroundColor = [UIColor blackColor];
    _topView.alpha = 0.5;
    [_background addSubview:_topView];
    
    //    //延迟线程
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _background.alpha = 0;
        }];
        
    });
}

#pragma mark -创建活动指示器(小菊花)
-(void)creatActivityView
{
    self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activity.center = _background.center;
    [self.view addSubview:_activity];
    [_activity startAnimating];
    
}

#pragma mark - 创建UIProgressView
- (void)createProgress
{
    self.progress = [[UIProgressView alloc]initWithFrame:CGRectMake(55, SCREEN_HEIGHT1 - 22.5 , SCREEN_WIDTH1 * 0.7, 10)];
    [_background addSubview:_progress];
}

#pragma mark - 创建UISlider以及slider滑动事件
- (void)createSlider
{
     self.slider = [[UISlider alloc]initWithFrame:CGRectMake(52, SCREEN_HEIGHT1 - 29 , SCREEN_WIDTH1 * 0.68 , 10)];
    [_background addSubview:_slider];
    [_slider setThumbImage:[UIImage imageNamed:@"进度.png"] forState:UIControlStateNormal];
    [_slider addTarget:self action:@selector(progressSlider:) forControlEvents:UIControlEventValueChanged];
    _slider.minimumTrackTintColor = [UIColor blueColor];
    
    //自定义进度条的变化
    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.slider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSliderAction:)];
    [_slider addGestureRecognizer:tap];
}

//滑动
- (void)progressSlider:(UISlider *)slider
{
    //拖动改变视频播放进度
    if (_player.status == AVPlayerStatusReadyToPlay) {
        
        //    //计算出拖动的当前秒数
        CGFloat total = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        
        
        NSInteger dragedSeconds = floorf(total * slider.value);
        
        
        //转换成CMTime才能给player来控制播放进度
        
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        
        [_player pause];
        
        [_player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
            
            [_player play];
            
        }];
        
    }
}


- (void)tapSliderAction:(UITapGestureRecognizer *)tap
{
    
    if (tap.state == UIGestureRecognizerStateEnded && _player.status == AVPlayerItemStatusReadyToPlay) {
        CGPoint location = [tap locationInView:_slider];
        float x = location.x;
        float r = x / _slider.frame.size.width;
        float value = (_slider.maximumValue - _slider.minimumValue) * r;
        _slider.value = value;
        
        
        //    //计算出拖动的当前秒数
        CGFloat total = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        
        
        NSInteger dragedSeconds = floorf(total * _slider.value);
        
        
        //转换成CMTime才能给player来控制播放进度
        
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        
        [_player pause];
        
        [_player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
            
            [_player play];
            
        }];
        
    }
    
}


#pragma mark - 创建播放时间
- (void)createCurrentTimeLabel
{
   self.currenTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH1*0.84, SCREEN_HEIGHT1 - 30, 100, 20)];
    [self.background addSubview:_currenTimeLabel];
    _currenTimeLabel.textColor = [UIColor whiteColor];
    _currenTimeLabel.font = [UIFont systemFontOfSize:12];
    _currenTimeLabel.text = @"00:00/00:00";
}



#pragma mark -创建计时器及事件
-(void)creatTimer
{
    //计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(Stack) userInfo:nil repeats:YES];
    
}

- (void)Stack
{
    if (_playerItem.duration.timescale != 0) {
        
        _slider.maximumValue = 1;//音乐总共时长
        _slider.value = CMTimeGetSeconds([_playerItem currentTime]) / (_playerItem.duration.value / _playerItem.duration.timescale);//当前进度
        
        //当前时长进度progress
        NSInteger proMin = (NSInteger)CMTimeGetSeconds([_player currentTime]) / 60;//当前秒
        NSInteger proSec = (NSInteger)CMTimeGetSeconds([_player currentTime]) % 60;//当前分钟
        
        //duration 总时长
        
        NSInteger durMin = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale / 60;//总秒
        NSInteger durSec = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale % 60;//总分钟
        self.currenTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld / %02ld:%02ld", (long)proMin, (long)proSec, (long)durMin, (long)durSec];
    }
    
    
    if (_player.status == AVPlayerStatusReadyToPlay) {
        [_activity stopAnimating];
    } else {
        [_activity startAnimating];
    }
    
}

#pragma mark - 创建播放按钮以及点击事件
- (void)creatButton
{

    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake(15, SCREEN_HEIGHT1 - 40, 30, 30);
    [startButton setBackgroundImage:[UIImage imageNamed:@"暂停.png"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"播放.png"] forState:UIControlStateSelected];
    [self.background addSubview:startButton];
    
    [startButton addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
- (void)startAction:(UIButton *)button
{
    if (button.selected) {
        
        [_player play];
        
        button.selected = NO;
        
    } else {
        [_player pause];
        
        button.selected = YES;
    }
    
    
    
}
#pragma mark - 创建顶部返回按钮点击事件方法
- (void)creatbackButton
{    //返回按钮
    
   
    UIButton *Backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    Backbutton.frame = CGRectMake(15, 15, 25, 25);
    [Backbutton setBackgroundImage:[UIImage imageNamed:@"abc_ic_ab_back_mtrl_am_alpha"] forState:UIControlStateNormal];
    [Backbutton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:Backbutton];
    
    
}



- (void)backButtonAction
{
    [self.timer invalidate];
    self.timer = nil;
   
    [self.player pause];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
}
#pragma -mark 收藏按钮
-(void)creatSaveButton
{
    _SaveBackbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _SaveBackbutton.frame = CGRectMake(SCREEN_WIDTH1 - 40, 15, 20, 20);
    [_SaveBackbutton setBackgroundImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
    [_SaveBackbutton setBackgroundImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateSelected];
    [_SaveBackbutton addTarget:self action:@selector(SaveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_SaveBackbutton];
    
    [[DataBaseUtil shareDataBase] createTableWithName:@"video" withTextArray:@[@"Image",@"title",@"content",@"videoUrl"]];

    
}
-(void)judge{
    
    NSArray *SaveArr = [[DataBaseUtil shareDataBase]selectTable:@"video" withClassName:@"XLHSpecialModal" withtextArray:@[@"Image",@"title",@"content",@"videoUrl"] withList:@"videoUrl" withYouWantSearchContent:_model.videoUrl];
    //    NSLog(@"%ld",SaveArr.count);
    
    if (SaveArr.count>0) {
        _isSave = YES;
        [_SaveBackbutton setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateNormal];
    }else{
        _isSave = NO;
        [_SaveBackbutton setImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
    }
    
}

-(void)SaveButtonAction:(UIButton *)sender
{
//    sender.selected = !sender.selected;
    if (!_isSave) {
        [_SaveBackbutton setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateNormal];
        [[DataBaseUtil shareDataBase]insertWithTableName:@"video" withObjectTextArray:@[@"Image",@"title",@"content",@"videoUrl"] withObjectValueArray:@[_model.Image,_model.title,_model.content,_model.videoUrl]];
        _isSave = YES;
    }else
    {
        [_SaveBackbutton setImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
        [[DataBaseUtil shareDataBase] deleteObjectWithTableName:@"video" withTextName:@"videoUrl" withValue:_model.videoUrl];
        _isSave = NO;
    }
    

}

#pragma mark - 创建标题
- (void)createTitle
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH1* 0.1,0, SCREEN_WIDTH1 * 0.76, SCREEN_HEIGHT1 * 0.15)];
    label.backgroundColor = [UIColor clearColor];
    label.text = self.model.title;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.background addSubview:label];
}


#pragma mark - 创建手势,主要实现每次轻拍屏幕获取系统音量且实现点击出现或隐藏backgroundview;
- (void)createGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    
    
    //获取系统音量
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _VolumSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _VolumSlider = (UISlider *)view;
            break;
        }
    }
    _systemVolume = _VolumSlider.value;
    
}

//每次轻拍点击出现或隐藏backgroundview
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (_background.alpha == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            
            _background.alpha = 0;
        }];
    } else if (_background.alpha == 0){
        [UIView animateWithDuration:0.5 animations:^{
            
            _background.alpha = 1;
        }];
    }
    if (_background.alpha == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.5 animations:^{
                
                _background.alpha = 0;
            }];
            
        });
        
    }
}

//滑动调整音量
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(event.allTouches.count == 1){
        //保存当前触摸的位置
        CGPoint point = [[touches anyObject] locationInView:self.view];
        _startPoint = point;
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if(event.allTouches.count == 1){
        //计算位移
        CGPoint point = [[touches anyObject] locationInView:self.view];
        float dy = point.y - _startPoint.y;
        int index = (int)dy;
        if(index>0)
        {
            if(index%2==0)
            {//每20个像素声音减一格
//                NSLog(@"%.2f",_systemVolume);
                if(_systemVolume>0.1){
                    _systemVolume = _systemVolume-0.01;
                    [_VolumSlider setValue:_systemVolume animated:YES];
                    [_VolumSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
        else
        {
            if(index%2==0){//每20个像素声音增加一格
//                NSLog(@"+x ==%d",index);
                NSLog(@"%.2f",_systemVolume);
                if(_systemVolume>=0 && _systemVolume<1)
                {
                    _systemVolume = _systemVolume+0.01;
                    [_VolumSlider setValue:_systemVolume animated:YES];
                    [_VolumSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
