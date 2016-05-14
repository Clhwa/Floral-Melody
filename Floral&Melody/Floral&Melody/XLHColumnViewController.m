//
//  XLHColumnViewController.m
//  Floral&Melody
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHColumnViewController.h"

#import "DataBaseUtil.h"
#import "LBProgressHUD.h"

@interface XLHColumnViewController ()<WKNavigationDelegate>
@property(nonatomic,assign)BOOL isCollect;
@end

@implementation XLHColumnViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlAddress]]];
    
    //代理
    self.webView.navigationDelegate = self;
    
    //设置收藏按钮
    [self setCollectButton];
    
    //设置主题
    [self setViewControllerTitleWith:_titleStr];
    
    //通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addLeftButton) name:@"kAddLeftButtonWithColumn" object:nil];
}
#pragma mark-代理方法
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
     [LBProgressHUD showHUDto:self.view animated:YES];//开始菊花
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [LBProgressHUD hideAllHUDsForView:self.view animated:YES];//停止菊花
}
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [LBProgressHUD hideAllHUDsForView:self.view animated:YES];//停止菊花
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [LBProgressHUD hideAllHUDsForView:self.view animated:YES];//停止菊花
}
#pragma mark-添加返回按钮
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
#pragma mark-设置收藏
-(void)setCollectButton
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    [button addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
   NSArray *array = [[DataBaseUtil shareDataBase]selectTable:@"article" withClassName:@"ListContent" withtextArray:@[@"Name",@"url",@"ImageUrl"] withList:@"url" withYouWantSearchContent:self.urlAddress];
    if (array.count>0) {
        [button setBackgroundImage:[UIImage imageNamed:@"收藏01"] forState:UIControlStateNormal];
        _isCollect = YES;
    }else{
        [button setBackgroundImage:[UIImage imageNamed:@"收藏02"] forState:UIControlStateNormal];
        _isCollect = NO;
    }

}
-(void)collect:(UIButton *)button
{
    if (_isCollect) {
        //取消收藏
        if ([[DataBaseUtil shareDataBase]deleteObjectWithTableName:@"article" withTextName:@"url" withValue:_urlAddress]) {
            _isCollect = NO;
            [button setBackgroundImage:[UIImage imageNamed:@"收藏02"] forState:UIControlStateNormal];
        }
    }else{
        //收藏
        if ([[DataBaseUtil shareDataBase]insertWithTableName:@"article" withObjectTextArray:@[@"Name",@"url",@"ImageUrl"] withObjectValueArray:@[_titleStr,_urlAddress,_imageUrl]]) {
            [button setBackgroundImage:[UIImage imageNamed:@"收藏01"] forState:UIControlStateNormal];
             _isCollect = YES;
            
        }
    }
    
}
- (void)popController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
