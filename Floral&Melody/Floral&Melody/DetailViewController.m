//
//  DetailViewController.m
//  Flower&Melody
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 BF. All rights reserved.
//

#import "DetailViewController.h"
#import <WebKit/WebKit.h>
#import "MJRefresh.h"
#import "WarnLabel.h"
#import "GoToTopButton.h"
#import "XLHMJRefresh.h"
#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
@interface DetailViewController ()<WKNavigationDelegate>

@property(nonatomic,strong)WKWebView *web;
@property(nonatomic,strong)UIActivityIndicatorView *act;
@property(nonatomic,strong)UILabel *collectView;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _web = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_web];
    _web.navigationDelegate = self;
    //异步
    [self performSelectorInBackground:@selector(loadWeb) withObject:nil];
    //添加刷新
//    [_web.scrollView addHeaderWithTarget:self action:@selector(refresh)];
    MJRefreshNormalHeader * header = [[XLHMJRefresh shareXLHMJRefresh] header];
    header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _web.scrollView.mj_header = header;
    //置顶
    GoToTopButton *button = [[GoToTopButton alloc]initWithFrame:CGRectMake(WIDTH-20-45, HEIGHT-64-20-45, 45, 45) withControlView:_web.scrollView];
    [self.view addSubview:button];

    //添加收藏按钮
    
    
    // Do any additional setup after loading the view.
}


#pragma amrk-刷新
-(void)refresh
{
    [_web reload];
}
#pragma mark-加载页面
-(void)loadWeb
{
    NSString *str =[NSString stringWithFormat: @"http://101.200.141.66:8080/EncyclopediaDetail?Id=%ld&Type=0",_iden];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_web loadRequest:request];
}
#pragma mark-代理方法
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self.act startAnimating];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [_web.scrollView.mj_header endRefreshing];
    [_act stopAnimating];
    WarnLabel *warnLab = [WarnLabel creatWarnLabelWithY:200 withSuperView:self.view];
    warnLab.text = @"网页加载成功";
}
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{//这个
    [_web.scrollView.mj_header endRefreshing];
    [_act stopAnimating];
    WarnLabel *warnLab = [WarnLabel creatWarnLabelWithY:200 withSuperView:self.view];
    warnLab.text = @"加载失败了,亲";
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [_web.scrollView.mj_header endRefreshing];
    [_act stopAnimating];
    WarnLabel *warnLab = [WarnLabel creatWarnLabelWithY:200 withSuperView:self.view];
    warnLab.text = @"加载失败了,亲";
}
#pragma mark-懒加载
-(UIActivityIndicatorView *)act
{
    if (!_act) {
        _act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:_act];
        _act.center = CGPointMake(self.view.frame.size.width/2, 200);
        _act.color = [UIColor lightGrayColor];
    }
    return _act;
}
-(UILabel *)collectView
{
    if (!_collectView) {
        _collectView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _collectView.backgroundColor = [UIColor blackColor];
        _collectView.alpha = 0.5;
        _collectView.text = @"收藏";
        _collectView.numberOfLines = 0;
        _collectView.textColor = [UIColor whiteColor];
    }
    return _collectView;
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
