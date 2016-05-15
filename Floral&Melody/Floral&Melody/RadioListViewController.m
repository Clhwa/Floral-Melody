//
//  RadioListViewController.m
//  Radio
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 Carman. All rights reserved.
//

#import "RadioListViewController.h"
#import "RadioListTableViewCell.h"
#import "PlayerViewController.h"
#import "UIImageView+WebCache.h"
//#import "MJRefresh.h"
#import "XLHMJRefresh.h"

#import "LBProgressHUD.h"//菊花
#import "WarnLabel.h"

#define KWidth self.view.bounds.size.width
#define KHeight self.view.bounds.size.height
#define HeaderViewHeight 150

@interface RadioListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL mybool;//用来修复bug
}
@property(nonatomic,strong)UIImageView *headerV;
@property(nonatomic,strong)UITableView *tableV;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic)NSInteger page;//网络请求的页数


@end

@implementation RadioListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _page = 10;
    [self Request];
    [self creatTableView];
//    [_tableV addHeaderWithTarget:self action:@selector(refresh)];
//    [_tableV addFooterWithTarget:self action:@selector(requestMore)];
    MJRefreshNormalHeader * header = [[XLHMJRefresh shareXLHMJRefresh] header];
    header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _tableV.mj_header = header;
    
    MJRefreshAutoNormalFooter * footer = [[XLHMJRefresh shareXLHMJRefresh] footer];
    footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMore)];
    _tableV.mj_footer = footer;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    //设置主题
    [self setViewControllerTitleWith:self.radio.title];
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
//刷新
-(void)refresh
{
    [self Request];
    [_tableV.mj_header endRefreshing];
}
-(void)requestMore
{
    [self requestMoreValue];

    [_tableV.mj_footer endRefreshing];
}
-(void)requestMoreValue
{
     [LBProgressHUD showHUDto:self.view animated:YES];//开始菊花
    
    _page =_page +10;
    NSLog(@"%ld",_page);
    
    NSString *str = @"http://api2.pianke.me/ting/radio_detail_list";
    
    NSURL *url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod  = @"POST";
    //添加请求体 (请求体是一个NSData 我们用post的目的是想保留一部分数据 我们将这部分数转化成NSData类型 放入请求体中)
    NSString *body = [NSString stringWithFormat:@"client=1&deviceid=6D4DD967-5EB2-40E2-A202-37E64F3BEA31&limit=%ld&radioid=%@&start=1®&version=4.0.4",_page,_radio.radioid];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    //会话
    NSURLSession *session = [NSURLSession sharedSession];
    
    //任务
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            if (_dataArray) {
                [_dataArray removeAllObjects];
            }

            //取数据
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *datadic = [dic objectForKey:@"data"];
            NSArray *listArr = [datadic objectForKey:@"list"];
            if (!_dataArray) {
                self.dataArray = [NSMutableArray array];
            }
            
            for (NSDictionary *dic in listArr) {
                RadioListModel *radio = [[RadioListModel alloc] init];
                
                //网页网址(音乐短文)
                NSDictionary *play = [dic objectForKey:@"playInfo"];
                radio.webview_url = [play objectForKey:@"webview_url"];
                
                NSDictionary *user = [play objectForKey:@"authorinfo"];
                radio.uname = [user objectForKey:@"uname"];
                
                
                NSDictionary *share = [play objectForKey:@"shareinfo"];
                radio.longTitle = [share objectForKey:@"title"];

                //NSLog(@"%@",radio.webview_url);
                //NSLog(@"%@",radio.uname);
                [radio setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:radio];
            }
//            NSLog(@"%ld",self.dataArray.count);
//            NSLog(@"%@",[[self.dataArray objectAtIndex:0] title]);
            
            //ui刷新回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableV reloadData];
                
                [self performSelector:@selector(removeAct) withObject:nil afterDelay:0.2];//停止菊花
            });
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self performSelector:@selector(removeAct) withObject:nil afterDelay:0.2];//停止菊花
                //提示框
                WarnLabel *warnLab = [WarnLabel creatWarnLabelWithY:200+64 withSuperView:self.view];
                warnLab.text = @"网络请求失败";
            });
            NSLog(@"%@",error);
        }
    }];
    //启动
    [task resume];
    
}
-(void)removeAct
{
    [LBProgressHUD hideAllHUDsForView:self.view animated:YES];//停止菊花
    
}
-(void)creatTableView
{
    //顶部大图
    self.headerV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64,KWidth , HeaderViewHeight)];
    _headerV.contentMode = UIViewContentModeScaleAspectFill;
    _headerV.clipsToBounds = YES;
    [self.headerV sd_setImageWithURL:[NSURL URLWithString:self.radio.coverimg]];
    
    //tableView
    self.tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KWidth, KHeight-49-64)];
    self.tableV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableV];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    
    _tableV.tableHeaderView = _headerV;
    
}
#pragma mark-屏幕出现
-(void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"y==%f",_tableV.frame.origin.y);
    if (!mybool) {
        mybool = YES;
    }else{
          [UIView animateWithDuration:0.15 animations:^{
        _tableV.frame = CGRectMake(0, 0, KWidth, KHeight-49);
                }];
    }
}
-(void)Request
{
     [LBProgressHUD showHUDto:self.view animated:YES];//开始菊花
    
    //(2)发送post
    NSString *str = @"http://api2.pianke.me/ting/radio_detail";
    
    NSURL *url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod  = @"POST";
    //添加请求体 (请求体是一个NSData 我们用post的目的是想保留一部分数据 我们将这部分数转化成NSData类型 放入请求体中)
    NSString *body = [NSString stringWithFormat:@"auth=&client=1&deviceid=63A94D37-33F9-40FF-9EBB-481182338873&radioid=%@&version=4.0.4",_radio.radioid];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    //    request.allHTTPHeaderFields = @{@"Content-Type":@"application/x-www-form-urlencoded",@"Content-Type":@"Content-Type"};
    //会话
    NSURLSession *session = [NSURLSession sharedSession];
    
    //任务
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //        NSLog(@"%@",string);
        
        if (data) {
            //取数据
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *datadic = [dic objectForKey:@"data"];
            NSArray *listArr = [datadic objectForKey:@"list"];
            if (!_dataArray) {
                self.dataArray = [NSMutableArray array];
            }
            [_dataArray removeAllObjects];
            for (NSDictionary *dic in listArr) {
                RadioListModel *radio = [[RadioListModel alloc] init];
                
                //网页网址(音乐短文)
                NSDictionary *play = [dic objectForKey:@"playInfo"];
                radio.webview_url = [play objectForKey:@"webview_url"];
                
                NSDictionary *user = [play objectForKey:@"authorinfo"];
                radio.uname = [user objectForKey:@"uname"];
                
                NSDictionary *share = [play objectForKey:@"shareinfo"];
                radio.longTitle = [share objectForKey:@"title"];
                
                //NSLog(@"%@",radio.webview_url);
                //NSLog(@"%@",radio.uname);
                [radio setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:radio];
                
                
            }
//            NSLog(@"%ld",self.dataArray.count);
//            NSLog(@"%@",[[self.dataArray objectAtIndex:0] title]);
            
            //ui刷新回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableV reloadData];
                
                [self performSelector:@selector(removeAct) withObject:nil afterDelay:0.2];//停止菊花
            });
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(removeAct) withObject:nil afterDelay:0.2];//停止菊花
                //提示框
                WarnLabel *warnLab = [WarnLabel creatWarnLabelWithY:200+64 withSuperView:self.view];
                warnLab.text = @"网络请求失败";
               
            });
            NSLog(@"%@",error);
        }
    }
        
        ];
    //启动
    [task resume];

}

#pragma -mark tableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifile = @"cell";
    RadioListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifile];
    if (cell==nil) {
        cell = [[RadioListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifile];
        
    }
    RadioListModel *radiomodel = [self.dataArray objectAtIndex:indexPath.row];
    cell.listModel = radiomodel;
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    PlayerViewController  *play = [[PlayerViewController alloc] init];
    play.musicArray = self.dataArray;
    play.currentIndex = indexPath.row;
    play.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:play animated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
