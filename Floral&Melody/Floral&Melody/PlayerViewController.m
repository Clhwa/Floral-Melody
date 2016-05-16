//
//  PlayerViewController.m
//  Radio
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 Carman. All rights reserved.
//

#import "PlayerViewController.h"
#import "UIImageView+WebCache.h"
#import "JJPlayer.h"
#import "RadioListModel.h"
#import "DataBaseUtil.h"
#define KWidth self.view.bounds.size.width
#define KHeight self.view.bounds.size.height
#define ControllerHeight 70
#define kJJColor(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]

@interface PlayerViewController ()<UIScrollViewDelegate,JJPlayerDeleger>

@property(nonatomic,strong)JJPlayer *player;
@property(nonatomic,strong)AVPlayerItem *PlayItem;
@property(nonatomic,strong)RadioListModel *radio;

@property(nonatomic,strong)UIImageView *backgroundView;//背景图
@property(nonatomic,strong)UISlider *musicProgrsee;//进度条
@property(nonatomic,strong)UILabel *currentTimeLable;//当前时间
@property(nonatomic,strong)UIImageView *reroatView;//滚动图片
@property(nonatomic,strong)UIScrollView *scrollV;//滚动视图
@property(nonatomic,strong)UIPageControl *pageControl;//分页
@property(nonatomic,strong)UIButton *backButton;//返回按钮
@property(nonatomic,strong)UIImageView *icon;//滚动视图
@property(nonatomic,strong)UIWebView *webView;//文章的网页
@property(nonatomic,strong)UIButton *start;//开始播放的按钮
@property(nonatomic)BOOL isplay;//是否播放

@property(nonatomic,strong)UILabel *Titlelabel;
@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UIButton *save;//收藏按钮
@property(nonatomic)BOOL isSave;//是否收藏;



//记住音频的时间
@property(nonatomic,assign)CGFloat sumTime;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self SetBackgroundView];
    [self creatScrollView];
    [self PlayButton];

    
    //建表
    [[DataBaseUtil shareDataBase] createTableWithName:@"RadioSave" withTextArray:@[@"coverimg",@"musicUrl",@"webview_url",@"uname",@"longTitle",@"title"]];
   
}
-(void)judge{

    NSArray *SaveArr = [[DataBaseUtil shareDataBase]selectTable:@"RadioSave" withClassName:@"RadioListModel" withtextArray:@[@"coverimg",@"musicUrl",@"webview_url",@"uname",@"longTitle",@"title"] withList:@"musicUrl" withYouWantSearchContent:_radio.musicUrl];
    //    NSLog(@"%ld",SaveArr.count);
    
    if (SaveArr.count>0) {
        _isSave = YES;
        [_save setImage:[UIImage imageNamed:@"save_2"] forState:UIControlStateNormal];
    }else{
        _isSave = NO;
        [_save setImage:[UIImage imageNamed:@"saveWhite"] forState:UIControlStateNormal];
    }

}
-(void)viewWillAppear:(BOOL)animated
{
    //一开始就播放
    [self reloadMusic];
    [self judge];
    [self creatSaveButton];
    NSLog(@"viewWillAppear");
}
#pragma  -mark收藏按钮
-(void)creatSaveButton
{
    _save = [UIButton buttonWithType:UIButtonTypeCustom];
    _save.frame = CGRectMake(KWidth-45, 25, 25, 25);
    [self.view addSubview:_save];
    if (!_isSave) {
        [_save setImage:[UIImage imageNamed:@"saveWhite"] forState:UIControlStateNormal];
    }else if (_isSave){
        [_save setImage:[UIImage imageNamed:@"save_2"] forState:UIControlStateNormal];
    }
    [_save addTarget:self action:@selector(SaveRadio:) forControlEvents:UIControlEventTouchDown];
}
-(void)SaveRadio:(UIButton *)sender
{
    if (!_isSave) {
        
        [_save setImage:[UIImage imageNamed:@"save_2"] forState:UIControlStateNormal];
        [[DataBaseUtil shareDataBase] insertWithTableName:@"RadioSave" withObjectTextArray:@[@"coverimg",@"musicUrl",@"webview_url",@"uname",@"longTitle",@"title"] withObjectValueArray:@[_radio.coverimg,_radio.musicUrl,_radio.webview_url,_radio.uname,_radio.longTitle,_radio.title]];
        _isSave = YES;
    }else if (_isSave){
    [_save setImage:[UIImage imageNamed:@"saveWhite"] forState:UIControlStateNormal];
        [[DataBaseUtil shareDataBase] deleteObjectWithTableName:@"RadioSave" withTextName:@"musicUrl" withValue:_radio.musicUrl];
        _isSave = NO;
    }
    
}
//背景图
-(void)SetBackgroundView
{
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationController.navigationBarHidden = YES;
    
    //背景图
    self.backgroundView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    [self.backgroundView sd_setImageWithURL:[NSURL URLWithString:self.music.coverimg]];
    
    self.backgroundView.userInteractionEnabled = YES;
    
    //毛玻璃效果
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    visualView.frame = self.backgroundView.frame;
    [self.backgroundView addSubview:visualView];
    [self.view addSubview:self.backgroundView];
    
    //返回按钮
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(20, 25, 23, 23);
    [self.backgroundView addSubview:self.backButton];
    [self.backButton setImage:[UIImage imageNamed:@"abc_ic_ab_back_mtrl_am_alpha"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(jumpBack) forControlEvents:UIControlEventTouchDown];
    
    //标题
    _Titlelabel = [[UILabel alloc] initWithFrame:CGRectMake((KWidth-200)/2, 15, 200, 20)];
    [self.backgroundView addSubview:_Titlelabel];
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((KWidth-200)/2, 35, 200, 20)];
    [self.backgroundView addSubview:_nameLabel];
//    Titlelabel.backgroundColor = [UIColor yellowColor];
//    nameLabel.backgroundColor = [UIColor yellowColor];
//    _Titlelabel.text = self.music.title;
    _Titlelabel.textAlignment = NSTextAlignmentCenter;
    _Titlelabel.font = [UIFont systemFontOfSize:14];
    _Titlelabel.textColor = [UIColor whiteColor];
    
//    _nameLabel.text = self.music.uname;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:10];
    _nameLabel.textColor = [UIColor whiteColor];

    
    //pagecontroller
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((KWidth-100)/2, KHeight-70 , 100, 10)];
    [self.backgroundView addSubview:_pageControl];
    _pageControl.numberOfPages = 2;
    //pag.backgroundColor = [UIColor orangeColor];//默认白色
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [_pageControl addTarget:self action:@selector(page:) forControlEvents:UIControlEventValueChanged];
    
}
//功能按钮
-(void)PlayButton
{
    _start = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.backgroundView addSubview:_start];
    [_start addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchDown];
    _start.frame = CGRectMake((KWidth-30)/2, KHeight-40, 30, 30);
    [_start setImage:[UIImage imageNamed:@"ic_action_pause"] forState:UIControlStateNormal];
    
    UIButton *back = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.backgroundView addSubview:back];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
    back.frame = CGRectMake(40, KHeight-40, 30, 30);
    [back setImage:[UIImage imageNamed:@"ic_prev"] forState:UIControlStateNormal];
    
    UIButton *next = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.backgroundView addSubview:next];
    [next addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchDown];
    next.frame = CGRectMake(KWidth-70, KHeight-40, 30, 30);
    [next setImage:[UIImage imageNamed:@"ic_next"] forState:UIControlStateNormal];

}
#pragma -mark每次切换歌曲的时候把页面的元素全部换成该歌曲的内容
-(void)reloadMusic
{
    //更换音乐播放器，让音乐播放器，播放当前的音乐
    JJPlayer *player = [JJPlayer sharedplayer];
    //切换的歌曲和当前正在播放的各不一样的时候，咱们在切歌
    //设置代理，让该视图控制器帮我们实现图片的旋转个歌词的滚动，以及进度条的滚动
    
    player.delegate = self;
    //在创建新的播放器的时候，要先把原来的停止，要不然定时器会越走越快
    
    //把原来的歌曲停掉
    [player pause];
    
    _radio = [_musicArray objectAtIndex:_currentIndex];
    _PlayItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:_radio.musicUrl]];
    [player setPlayerWithAVPlayerItem:_PlayItem];
    
    [player play];

    if ([_player isPlaying]) {
        [_start setImage:[UIImage imageNamed:@"ic_action_play"] forState:UIControlStateNormal];
    }else
    {
        [_start setImage:[UIImage imageNamed:@"ic_action_pause"] forState:UIControlStateNormal];
    }
    //1.背景图
    [self.backgroundView sd_setImageWithURL:[NSURL URLWithString:_radio.coverimg]placeholderImage:[UIImage imageNamed:@"占位花"]];
    //2.旋转图
    [_icon sd_setImageWithURL:[NSURL URLWithString:_radio.coverimg]];
    
    //3.根据每首歌自己不同的长度，改变音乐进度条的最大值
    
    _currentTimeLable.text = @"0:00/0:00";
    CMTime alltime = [_PlayItem duration];
    //转化成秒
    CGFloat sumtime = CMTimeGetSeconds(alltime);
    if (alltime.value!=0) {
        //4.当前播放位置
        CGFloat currentTime =  _PlayItem.currentTime.value/_PlayItem.currentTime.timescale;
        NSString *current = [self timeWithInterVal:currentTime];
        NSString *sumtimestr = [self timeWithInterVal:sumtime];
        _currentTimeLable.text = [NSString stringWithFormat:@"%@/%@",current,sumtimestr];
    }
    
    //5
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_radio.webview_url]]];
    
    //6
    _nameLabel.text = _radio.uname;
    _Titlelabel.text = _radio.title;
    
    //保证每次切换新歌的时候旋转的图片都从正上方看是旋转
    self.reroatView.transform = CGAffineTransformMakeRotation(0);
    
}

#pragma -mark播放器的协议方法(0.1s就会调用一次)
-(void)audioPlayer:(JJPlayer *)player didPlayingWithProgress:(float)progress
{

    //主要处理播放过程中需要持续性改变的都写在这里面，因为这个方法，会每隔0.1s就会被调用一次
    
    //1.根据每首歌自己不同的长度，改变音乐进度条的最大值
    CMTime alltime = [_PlayItem duration];
    if (alltime.timescale!=0) {
        //转化成秒
        CGFloat sumtime = CMTimeGetSeconds(alltime);
        _currentTimeLable.text = @"0:00/0:00";
        
        //4.当前播放位置
        CGFloat currentTime =  _PlayItem.currentTime.value/_PlayItem.currentTime.timescale;
//        NSLog(@"currentTime=%f   _sumTime=%f",currentTime,sumtime);
//        NSLog(@"%f",progress);
        //1.设置音乐播放的进度条()
        self.musicProgrsee.maximumValue = sumtime;
        self.musicProgrsee.value = progress;
#pragma mark - time2
        NSString *current = [self timeWithInterVal:currentTime];
        NSString *sumtimestr = [self timeWithInterVal:sumtime];
        _currentTimeLable.text = [NSString stringWithFormat:@"%@/%@",current,sumtimestr];


    }
    //3让图片进行旋转
    _reroatView.transform = CGAffineTransformRotate(self.reroatView.transform, M_PI/360);

}
#pragma -mark播放完成后执行的方法
-(void)audioPlayerDidFinishPlaying:(JJPlayer *)player
{
   //下一曲
    [self next:nil];
}


#pragma -mark 功能按钮播放音乐
-(void)start:(UIButton *)sender
{
    
    JJPlayer *player = [JJPlayer sharedplayer];
    if ([player isPlaying]) {
        //如果能进到这个if里面里面说明，当前是正在播放的，进来之后就要暂停
        [player pause];
        [sender setImage:[UIImage imageNamed:@"ic_action_play"] forState:UIControlStateNormal];

    }else//从暂停状态到播放状态，
    {
        [player play];
        //同时也要改变button的图片
        [sender setImage:[UIImage imageNamed:@"ic_action_pause"] forState:UIControlStateNormal];
    }
}
#pragma -mark点击上一首按钮执行的方法
-(void)back:(UIButton *)sender
{
    
    if (_currentIndex!=0) {
        self.currentIndex--;
    }else{
        self.currentIndex = _musicArray.count-1;
    }
    
    [self reloadMusic];
    [self judge];

}
-(void)next:(UIButton *)sender
{
    if (_currentIndex!=_musicArray.count-1) {
        self.currentIndex++;
    }else{
        self.currentIndex = 0;
    }
    
    [self reloadMusic];
    [self judge];
}


//返回按钮的方法
-(void)jumpBack
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//分页的方法
-(void)page:(UIPageControl *)sender
{
    _scrollV.contentOffset = CGPointMake(KWidth*sender.currentPage, 0);
//    NSLog(@"%ld",sender.currentPage);

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x/KWidth;
//    NSLog(@"%f",scrollView.contentOffset.x/KWidth);
}


//滚动视图
-(void)creatScrollView
{
    self.scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 55, KWidth, KHeight-55-70)];
    [self.backgroundView addSubview:self.scrollV];
    
    self.scrollV.contentSize = CGSizeMake(KWidth*2, 0);
    self.scrollV.showsHorizontalScrollIndicator = NO;
//    self.scrollV.backgroundColor = [UIColor cyanColor];
    self.scrollV.pagingEnabled = YES;
    
    self.scrollV.delegate = self;
    
    self.reroatView = [[UIImageView alloc] initWithFrame:CGRectMake((KWidth-280)/2, (KHeight-55-70-340)/2, 280, 280)];
    _reroatView.image = [UIImage imageNamed:@"music"];
    _reroatView.userInteractionEnabled = YES;
    
    
    //旋转图片
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 220)];
//    [_icon sd_setImageWithURL:[NSURL URLWithString:self.music.coverimg]];
    [self.reroatView addSubview:_icon];
    _icon.center = CGPointMake(_reroatView.bounds.size.width/2, _reroatView.bounds.size.height/2);
    _icon.layer.cornerRadius = 110;
    _icon.layer.masksToBounds = YES;
    [_scrollV addSubview:_reroatView];
    
    
    //webview
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(KWidth, 0, KWidth, KHeight-55-70)];
    [self.scrollV addSubview:self.webView];
    
   
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.music.webview_url]]];

  
    _webView.backgroundColor = [UIColor clearColor];
    
    //进度条
    self.musicProgrsee = [[UISlider alloc] initWithFrame:CGRectMake((KWidth-(KWidth-80))/2, KHeight-90-55, (KWidth-80), 20)];
    [_scrollV addSubview:_musicProgrsee];
    
    //进度条
    self.musicProgrsee.minimumTrackTintColor = kJJColor(200, 150, 100);
    self.musicProgrsee.maximumTrackTintColor = [UIColor whiteColor];
    [self.musicProgrsee setThumbImage:[UIImage imageNamed:@"swith"] forState:UIControlStateNormal];
    [self.musicProgrsee addTarget:self action:@selector(progressChange:) forControlEvents:UIControlEventValueChanged];
    
    //时间
    _currentTimeLable = [[UILabel alloc] initWithFrame:CGRectMake((KWidth-80)/2, KHeight-55-110, 80, 20)];
    [_scrollV addSubview:_currentTimeLable];
    _currentTimeLable.font = [UIFont systemFontOfSize:12];
    _currentTimeLable.textAlignment = NSTextAlignmentCenter;
    _currentTimeLable.textColor = [UIColor whiteColor];

}

-(void)progressChange:(UISlider *)sender
{
    [[JJPlayer sharedplayer] seekToTime:sender.value];
}
#pragma -mark处理时间格式的方法
-(NSString *)timeWithInterVal:(float)interVal
{
    int minute = interVal / 60;
    int second = (int)interVal % 60;
    return [NSString stringWithFormat:@"%d:%02d",minute,second];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
