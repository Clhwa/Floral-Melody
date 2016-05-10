//
//  XLHFlowerViewController.m
//  Floral&Melody
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHFlowerViewController.h"


#import "UIImageView+WebCache.h"
@interface XLHFlowerViewController ()
{
    NSInteger pageNumber;
    NSInteger pageSize;
}
@end
static NSString * ID = @"cell";
@implementation XLHFlowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    
    [self requestData];
    
    UIImage * backImage = [UIImage imageNamed:@"返回"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(popController)];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}
- (void)popController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = COLOR(241, 241, 241, 1);
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[XLHColumnTableViewCell class] forCellReuseIdentifier:ID];
    
    [self.view addSubview:self.tableView];
}

/*
 * cell的个数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

/*
 * cell的设置
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    XLHColumnTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XLHColumnTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    XLHSpecialModal * xlh = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = xlh.title;
    cell.contentLabel.text = xlh.content;
    cell.typeLabel.text = xlh.type;
    cell.userNameLabel.text = xlh.userName;
    cell.identifierLabel.text = xlh.identifier;
    cell.timeLabel.text = xlh.time;
    cell.readerLabel.text =  [NSString stringWithFormat:@"%ld", xlh.reader];
    [cell.ImageView sd_setImageWithURL:[NSURL URLWithString:xlh.Image] placeholderImage:[UIImage imageNamed:@"piaobaoying"] options:SDWebImageDelayPlaceholder progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    [cell.IconImageView sd_setImageWithURL:[NSURL URLWithString:xlh.userIcon] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    

    return cell;
}

/*
 * cell的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.6;
}

/** 点击方法*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLHColumnViewController * column = [[XLHColumnViewController alloc] init];
    
    XLHSpecialModal *  xlh = [self.dataArray objectAtIndex:indexPath.row];
    
    column.urlAddress = xlh.pageUrl;
    
    [self.navigationController pushViewController:column animated:YES];
}


/** 初始化常量*/
- (void)initColumn
{
    pageSize = 5;
    pageNumber = 0;
}

/** 请求数据*/
- (void)requestData
{
    //初始化manager
    AFHTTPSessionManager * AFManager = [AFHTTPSessionManager manager];
    
    //不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    AFManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //post请求
    [AFManager POST:[NSString stringWithFormat:_API,pageNumber,pageSize] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
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
        
        [self.tableView reloadData];
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
    [AFManager POST:[NSString stringWithFormat:_API, 0,pageSize] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
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
        [self.tableView reloadData];
        NSLog(@"%ld",self.dataArray.count);
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
    [AFManager POST:[NSString stringWithFormat:_API,pageNumber,pageSize ] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
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
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"专题请求失败");
    }];
    
}


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
