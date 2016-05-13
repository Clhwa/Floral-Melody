  //
//  XLHVideoViewController.m
//  Floral&Melody
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHVideoViewController.h"

@interface XLHVideoViewController ()
{
    NSInteger pageNumber;
    NSInteger pageSize;
}
@end

@implementation XLHVideoViewController
#pragma mark - lazy
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)initNSInteger
{
    pageNumber = 0;
    pageSize = 5;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNSInteger];
    
    [self createTableView];
    [self createMJRefresh];
    [self requestData];
}

#pragma mark-主题
-(void)setViewControllerTitleWith:(NSString *)title
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:18];
    self.navigationItem.titleView = label;
}

/** 创建tableView*/
- (void)createTableView
{
    
    /** NavigationBar---Title*/
//    self.navigationItem.title = @"视频";
    //设置主题
    [self setViewControllerTitleWith:@"视频"];

    
    /*
     * 创建tableView
     */
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    _tableView.backgroundColor = [UIColor whiteColor];
    
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}
#pragma mark - tableView dataSouce
/** cell --- > count*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataArray.count;
}

/** cell ---> setting*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    XLHTOPTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XLHTOPTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier type:TOPONE];
    }
    
    [cell layoutSubviewsWithType:TOPONE];
    XLHSpecialModal * xlh = [self.dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = xlh.title;

    [cell.ImageView sd_setImageWithURL:[NSURL URLWithString:xlh.Image] placeholderImage:[UIImage imageNamed:@"piaobaoying"] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
    }];
    return cell;
}

/** cell ---> height*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.209;
}

/** cell ---> selected*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLHColumnViewController * column = [[XLHColumnViewController alloc] init];
    
    XLHSpecialModal * xlh = [self.dataArray objectAtIndex:indexPath.row];
    
    column.urlAddress = xlh.pageUrl;
    
    [self.navigationController pushViewController:column animated:YES];
}
#pragma mark - requestData
/** 请求数据*/
- (void)requestData
{
    //初始化manager
    AFHTTPSessionManager * AFManager = [AFHTTPSessionManager manager];
    
    //不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    AFManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //post请求
    [AFManager POST:[NSString stringWithFormat:@"http://m.htxq.net/servlet/SysArticleServlet?action=mainList&currentPageIndex=%ld&isVideo=true&pageSize=%ld",pageNumber,pageSize ] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"专题请求进度");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //获取最外层字典
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        //获取结果数组
        NSArray * resultArray = [dic valueForKey:@"result"];
        
        //遍历数组获取数据
        for (NSDictionary * dic in resultArray) {
            
            XLHSpecialModal * xlh = [[XLHSpecialModal alloc] init];
            
            xlh.Image = [dic valueForKey:@"smallIcon"];
            xlh.title = [dic valueForKey:@"title"];
            xlh.content = [dic valueForKey:@"desc"];
            xlh.reader = [[dic valueForKey:@"read"] integerValue];
            xlh.time = [xlh getTime:[dic valueForKey:@"createDate"]];
            xlh.pageUrl = [dic valueForKey:@"pageUrl"];
            xlh.type =  [xlh getType:[[dic valueForKey:@"category"] valueForKey:@"name"]];
            xlh.userName = [[dic valueForKey:@"author"] valueForKey:@"userName"];
            xlh.identifier = [[dic valueForKey:@"author"] valueForKey:@"identity"];
            xlh.userIcon = [[dic valueForKey:@"author"] valueForKey:@"headImg"];
            [self.dataArray addObject:xlh];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"专题请求失败");
    }];
    
}

/** update刷新数据 */
- (void)updateRequest
{
    
    //初始化manager
    AFHTTPSessionManager * AFManager = [AFHTTPSessionManager manager];
    
    //不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    AFManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //post请求
    [AFManager POST:[NSString stringWithFormat:@"http://m.htxq.net/servlet/SysArticleServlet?action=mainList&currentPageIndex=%d&isVideo=true&pageSize=%ld", 0,pageSize] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"专题请求进度");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //获取最外层字典
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        //获取结果数组
        NSArray * resultArray = [dic valueForKey:@"result"];
        
        //遍历数组获取数据
        [self.dataArray removeAllObjects];
        for (NSDictionary * dic in resultArray) {
            
            XLHSpecialModal * xlh = [[XLHSpecialModal alloc] init];
            
            xlh.Image = [dic valueForKey:@"smallIcon"];
            xlh.title = [dic valueForKey:@"title"];
            xlh.content = [dic valueForKey:@"desc"];
            xlh.reader = [[dic valueForKey:@"read"] integerValue];
            xlh.time = [xlh getTime:[dic valueForKey:@"createDate"]];
            xlh.pageUrl = [dic valueForKey:@"pageUrl"];
            xlh.type =  [xlh getType:[[dic valueForKey:@"category"] valueForKey:@"name"]];
            xlh.userName = [[dic valueForKey:@"author"] valueForKey:@"userName"];
            xlh.identifier = [[dic valueForKey:@"author"] valueForKey:@"identity"];
            xlh.userIcon = [[dic valueForKey:@"author"] valueForKey:@"headImg"];
            [self.dataArray addObject:xlh];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            NSLog(@"刷新数据 : %ld",self.dataArray.count);
            pageNumber = 0;
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"专题请求失败");
    }];
    
}

/** loadMore*/
- (void)loadMoreRequest
{
    //初始化manager
    AFHTTPSessionManager * AFManager = [AFHTTPSessionManager manager];
    
    //不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    AFManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //post请求
    [AFManager POST:[NSString stringWithFormat:@"http://m.htxq.net/servlet/SysArticleServlet?action=mainList&currentPageIndex=%ld&isVideo=true&pageSize=%ld",pageNumber,pageSize ] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"专题请求进度");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //获取最外层字典
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        //获取结果数组
        NSArray * resultArray = [dic valueForKey:@"result"];
        
        //遍历数组获取数据
        for (NSDictionary * dic in resultArray) {
            
            XLHSpecialModal * xlh = [[XLHSpecialModal alloc] init];
            
            xlh.Image = [dic valueForKey:@"smallIcon"];
            xlh.title = [dic valueForKey:@"title"];
            xlh.content = [dic valueForKey:@"desc"];
            xlh.reader = [[dic valueForKey:@"read"] integerValue];
            xlh.time = [xlh getTime:[dic valueForKey:@"createDate"]];
            xlh.pageUrl = [dic valueForKey:@"pageUrl"];
            xlh.type =  [xlh getType:[[dic valueForKey:@"category"] valueForKey:@"name"]];
            xlh.userName = [[dic valueForKey:@"author"] valueForKey:@"userName"];
            xlh.identifier = [[dic valueForKey:@"author"] valueForKey:@"identity"];
            xlh.userIcon = [[dic valueForKey:@"author"] valueForKey:@"headImg"];
            [self.dataArray addObject:xlh];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            NSLog(@"%ld",self.dataArray.count);
            [self.tableView.mj_footer endRefreshing];
            
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"专题请求失败");
    }];
    
}

#pragma mark - MJRefresh
/** 创建MJRefresh*/
- (void)createMJRefresh
{
    
    /*
     *  author @西兰花
     *
     *  2016 - 05 - 03
     *
     *  All rights reserved.
     */
    
    
    /*
     * headerView --- Updating *
     */
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self updateRequest];
    }];
    
    /* Text */
    [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    
    /* Font */
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:11];
    
    /* Color */
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
    
    self.tableView.mj_header = header;
    
    [self.tableView.mj_header beginRefreshing];
    
    
    /*
     * footerView --- LoadData *
     */
    
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    /* Text */
    [footer setTitle:@"Click or drag up to refresh" forState:MJRefreshStateIdle];
    [footer setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"No more data" forState:MJRefreshStateNoMoreData];
    
    /* Font */
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    
    /* Color */
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    
    self.tableView.mj_footer = footer;
    
}
/** footerView --- LoadData **/
- (void)loadMoreData
{
    pageNumber = pageNumber + 1;
    [self loadMoreRequest];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
