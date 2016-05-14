//
//  XLHTOPViewController.m
//  Floral&Melody
//
//  Created by lanou on 16/5/6.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHTOPViewController.h"
#import "LBProgressHUD.h"
#import "WarnLabel.h"
@interface XLHTOPViewController ()

    

@end

@implementation XLHTOPViewController
#pragma mark - lazy
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
    [self requestData];
    
    UIImage * backImage = [UIImage imageNamed:@"返回"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(popController)];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;

//设置主题
[self setViewControllerTitleWith:@"TOP"];
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

- (void)popController
{
    [self.navigationController popViewControllerAnimated:YES];
}

/** 创建tableView*/
- (void)createTableView
{
  
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    _tableView.backgroundColor = [UIColor whiteColor];
    
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}

#pragma mark - requestData
/** 请求数据*/
- (void)requestData
{
     [LBProgressHUD showHUDto:self.view animated:YES];//开始菊花
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:@"http://ec.htxq.net/servlet/SysArticleServlet?action=topContents&currentPageIndex=0&pageSize=15&(null)=" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             //获取最外层字典
//             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             
             NSDictionary * dic = responseObject;
             
             //获取result数组
             NSArray * resultArray = [dic valueForKey:@"result"];
             //遍历数组
             for (NSDictionary * dic in resultArray) {
                 XLHTOPModal * top = [[XLHTOPModal alloc] init];
                 top.title = [dic valueForKey:@"title"];
                 top.smallIcon = [dic valueForKey:@"smallIcon"];
                 top.pageUrl = [dic valueForKey:@"pageUrl"];
                 
                 [self.dataArray addObject:top];
             }
             [self.tableView reloadData];
             
             [LBProgressHUD hideAllHUDsForView:self.view animated:YES];//停止菊花
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             [LBProgressHUD hideAllHUDsForView:self.view animated:YES];//停止菊花
             
             WarnLabel *warn = [WarnLabel creatWarnLabelWithY:200 withSuperView:self.view];
             warn.text = @"网络请求失败";
             NSLog(@"%@",error);  //这里打印错误信息
             
         }];
}

#pragma mark - tableView datasouce
/** cell的个数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

/** cell的设置*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier1 = @"cell1";
    static NSString * identifier2 = @"cell2";
    if (indexPath.row < 3) {
        XLHTOPTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier1 ];
        if (cell == nil) {
            cell = [[XLHTOPTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier1 type:TOPONE];
        }
        [cell layoutSubviewsWithType:TOPONE];
        
        XLHTOPModal *top = [self.dataArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = top.title;
        cell.topLabel.text = [@"TOP " stringByAppendingString:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
        [cell.ImageView sd_setImageWithURL:[NSURL URLWithString:top.smallIcon] placeholderImage:[UIImage imageNamed:@"piaobaoying"] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        return cell;
    }
    else
    {
        XLHTOPTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier2 ];
        if (cell == nil) {
            cell = [[XLHTOPTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier2 type:TOPOTHER];
        }
        [cell layoutSubviewsWithType:TOPOTHER];
        XLHTOPModal *top = [self.dataArray objectAtIndex:indexPath.row];
        cell.OtherTitleLabel.text = top.title;
        cell.OtherTopLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
        [cell.OtherImageView sd_setImageWithURL:[NSURL URLWithString:top.smallIcon] placeholderImage:[UIImage imageNamed:@"piaobaoying"] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        return cell;
    }
}

/** cell的高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.209;
}

/** cell ---> selected*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLHTOPModal * top = [self.dataArray objectAtIndex:indexPath.row];
    XLHColumnViewController * column = [[XLHColumnViewController alloc] init];
    column.titleStr = top.title;//主题
    column.imageUrl = top.smallIcon;//图片
    column.urlAddress = top.pageUrl;
    [self.navigationController pushViewController:column animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
