//
//  DetailViewController.m
//  Flower&Melody
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 BF. All rights reserved.
//

#import "DetailViewController.h"

#import "DataBaseUtil.h"
#import "WarnLabel.h"
#import "GoToTopButton.h"
#import "XLHMJRefresh.h"
#import "LBProgressHUD.h" //菊花

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
@interface DetailViewController ()<UIScrollViewDelegate,UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *web;
//@property(nonatomic,strong)UIActivityIndicatorView *act;
@property(nonatomic,strong)UIButton *collectView;
@property(nonatomic,strong)GoToTopButton *button;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置主题
    [self setViewControllerTitleWith:_list.Name];
    
    _web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_web];
    _web.scrollView.delegate = self;
    _web.delegate = self;
    
    //加载
    [self loadWeb];
    //添加刷新
    MJRefreshNormalHeader * header = [[XLHMJRefresh shareXLHMJRefresh] header];
    header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _web.scrollView.mj_header = header;
    

    //添加收藏按钮
    [self.view addSubview:self.collectView];
    
    
    //通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addLeftButton) name:@"kAddLeftButton" object:nil];
    
    // Do any additional setup after loading the view.

}

#pragma mark-present添加返回按钮
-(void)addLeftButton
{
    //返回按钮
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(20, 25, 20, 20);
    [back setImage:[UIImage imageNamed:@"com_taobao_tae_sdk_web_view_title_bar_back.9"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(jumpBack) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];
}
-(void)jumpBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark-主题
-(void)setViewControllerTitleWith:(NSString *)title
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:16];
    self.navigationItem.titleView = label;
}
#pragma mark-出现
-(void)appearCollectButton
{
    [UIView animateWithDuration:0.3 animations:^{
        self.collectView.alpha = 0.6;
        self.button.alpha = 0.6;
    }];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self appearCollectButton];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self appearCollectButton];
}

#pragma mark-滚动隐藏
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![self.view.subviews containsObject:self.button]) {
        [self.view addSubview:self.button];
    }
    
    if (self.collectView.alpha != 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.collectView.alpha = 0;
            self.button.alpha = 0;
        }];
    }
}

#pragma amrk-刷新
-(void)refresh
{
    [_web reload];
}
#pragma mark-加载页面
-(void)loadWeb
{
    NSURL *url = [NSURL URLWithString:_list.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_web loadRequest:request];
}
#pragma mark-代理方法
-(void)webViewDidStartLoad:(UIWebView *)webView
{
//    [self.act startAnimating];
    [LBProgressHUD showHUDto:self.view animated:YES];//开始菊花
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_web.scrollView.mj_header endRefreshing];
//    [_act stopAnimating];
    [self performSelector:@selector(removeAct) withObject:nil afterDelay:0.2];//停止菊花
    
    WarnLabel *warnLab = [WarnLabel creatWarnLabelWithY:200+64 withSuperView:self.view];
    warnLab.text = @"网页加载成功";
    [self performSelector:@selector(appearCollectButton) withObject:nil afterDelay:0.8];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_web.scrollView.mj_header endRefreshing];
//    [_act stopAnimating];
    [self performSelector:@selector(removeAct) withObject:nil afterDelay:0.2];//停止菊花
    //提示框
    WarnLabel *warnLab = [WarnLabel creatWarnLabelWithY:200+64 withSuperView:self.view];
        warnLab.text = @"加载失败了,亲";

    [self performSelector:@selector(appearCollectButton) withObject:nil afterDelay:0.8];
}
-(void)removeAct
{
    [LBProgressHUD hideAllHUDsForView:self.view animated:YES];//停止菊花
    
}
#pragma mark-懒加载
-(GoToTopButton *)button
{
    if (!_button) {
        //置顶
        _button = [[GoToTopButton alloc]initWithFrame:CGRectMake(WIDTH-20-45, HEIGHT-64-20-45, 45, 45) withControlView:_web.scrollView];
    }
    return _button;
}
//-(UIActivityIndicatorView *)act
//{
//    if (!_act) {
//        _act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        [self.view addSubview:_act];
//        _act.center = CGPointMake(self.view.frame.size.width/2, 200);
//        _act.color = [UIColor lightGrayColor];
//    }
//    return _act;
//}
#pragma makr-收藏
-(void)collect
{
    //没有查询到有没有收藏就返回
    if ([self.collectView.titleLabel.text isEqualToString:@"查询中"]) {
        return;
    }
    //判断
    BOOL b = NO;
    NSString *str = [NSString string];
    NSString *warnStr = nil;
    if ([self.collectView.titleLabel.text isEqualToString:@"收藏"]) {
        if([[DataBaseUtil shareDataBase]insertWithTableName:@"baike"withObjectTextArray:@[@"Name",@"url",@"ImageUrl",@"Text"] withObjectValueArray:@[_list.Name,_list.url,_list.ImageUrl,_list.Text]]){
            b = YES;
        }
        str = @"已收藏";
        warnStr = @"收藏成功";
    }else if ([self.collectView.titleLabel.text isEqualToString:@"已收藏"]){
        if ([[DataBaseUtil shareDataBase]deleteObjectWithTableName:@"baike" withTextName:@"url" withValue:_list.url]) {
            b = YES;
        }
        str = @"收藏";
        warnStr = @"取消收藏";
    }
    //如果数据库操作失败就返回
    if (!b) {
        return;
    }
    //动画
    [UIView animateWithDuration:0.2 animations:^{
        self.collectView.transform = CGAffineTransformMakeTranslation(self.collectView.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.collectView.transform = CGAffineTransformIdentity;
            [self.collectView setTitle:str forState:UIControlStateNormal];
        }];
    }];
    //提示
    WarnLabel *warnLab = [WarnLabel creatWarnLabelWithY:HEIGHT/2 withSuperView:self.view];
    warnLab.text = warnStr;
}

-(UIButton *)collectView
{
    if (!_collectView) {
        _collectView = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectView.frame = CGRectMake(WIDTH-25, 150, 30, 80);
        _collectView.backgroundColor = [UIColor blackColor];
        _collectView.alpha = 0.6;
        [_collectView setTitle:@"查询中" forState:UIControlStateNormal];
        //子线程
        [self performSelectorInBackground:@selector(selectArr) withObject:nil];
        
        _collectView.titleLabel.numberOfLines = 0;
        [_collectView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _collectView.layer.cornerRadius = 5;
        _collectView.layer.masksToBounds = YES;
        
        [_collectView addTarget:self action:@selector(collect) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _collectView;
}
#pragma mark-判断此页面是否已收藏
-(void)selectArr
{
    NSArray *array = [[DataBaseUtil shareDataBase]selectTable:@"baike" withClassName:@"ListContent" withtextArray:@[@"Name",@"url",@"ImageUrl",@"Text"] withList:@"url" withYouWantSearchContent:_list.url];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (array.count>0) {
            [_collectView setTitle:@"已收藏" forState:UIControlStateNormal];//判断是否已收藏
        }else{
            [_collectView setTitle:@"收藏" forState:UIControlStateNormal];
        }
    });
   
    

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
