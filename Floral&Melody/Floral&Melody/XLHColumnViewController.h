//
//  XLHColumnViewController.h
//  Floral&Melody
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHBaseViewController.h"

@import WebKit;

@interface XLHColumnViewController : XLHBaseViewController

@property (nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)NSString *imageUrl;
@property (nonatomic , strong)NSString * urlAddress;
@property(nonatomic,strong)NSString *titleStr;
@end
