//
//  XLHColumnViewController.m
//  Floral&Melody
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHColumnViewController.h"
#import "DataBaseUtil.h"

@interface XLHColumnViewController ()
@property(nonatomic,assign)BOOL isCollect;
@end

@implementation XLHColumnViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlAddress]]];
    
    //设置收藏按钮
    [self setCollectButton];
    
    //设置主题
    [self setViewControllerTitleWith:_titleStr];
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
