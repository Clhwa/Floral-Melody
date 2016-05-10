//
//  XLHColumnViewController.m
//  Floral&Melody
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHColumnViewController.h"

@interface XLHColumnViewController ()

@end

@implementation XLHColumnViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlAddress]]];
    
    
    
}
- (void)popController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
