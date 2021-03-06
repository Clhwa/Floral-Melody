//
//  RadioViewController.m
//  Radio
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 Carman. All rights reserved.
//

#import "RadioViewController.h"
#import "LBProgressHUD.h" //菊花
#import "AFNetworking.h"
#import "RadioModel.h"
#import "RPSlidingMenuCell.h"
#import "RPSlidingMenuLayout.h"
#import "NetworkRequestManager.h"
#import "UIImageView+WebCache.h"
#import "RadioListViewController.h"
//#import "MJRefresh.h"
#import "XLHMJRefresh.h"
#import "WarnLabel.h"
@interface RadioViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSMutableArray *dataArray;//数据源数组
@property(nonatomic,strong)UICollectionView *collectV;
@property(nonatomic,assign)NSInteger number;//上拉加载请求的数据的数量
@property(nonatomic,strong)RPSlidingMenuLayout *layout;
@property(nonatomic)CGFloat conentOffsetY;
@property(nonatomic)BOOL isrefresh;

@end

@implementation RadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _number = 10;
    [self collectionView];
    
    
//    [self.collectV addHeaderWithTarget:self action:@selector(refresh)];
    MJRefreshNormalHeader * header = [[XLHMJRefresh shareXLHMJRefresh] header];
    header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _collectV.mj_header = header;

    
    //设置主题
    [self setViewControllerTitleWith:@"电台"];

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
-(void)refresh
{
    [self requestMore];
}
-(void)collectionView
{
    
   _layout = [[RPSlidingMenuLayout alloc] initWithDelegate:nil];
    self.collectV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-49-64) collectionViewLayout:_layout];
    [self.view addSubview:_collectV];
    
    _collectV.delegate = self;
    _collectV.dataSource = self;
    
    //设置偏移量
   _collectV.contentInset = UIEdgeInsetsMake(0, 0, -(800), 0);
   
//    NSLog(@"--------------->%f",_collectV.contentInset.bottom);
    

    [_collectV registerClass:[RPSlidingMenuCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.collectV.backgroundColor = [UIColor whiteColor];
    self.collectV.showsVerticalScrollIndicator = NO;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RPSlidingMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"forIndexPath:indexPath];
    if (_dataArray.count>0) {
        cell.textLabel.text = [[self.dataArray objectAtIndex:indexPath.item] title];
        cell.detailTextLabel.text = [[self.dataArray objectAtIndex:indexPath.item] desc];
       [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[[self.dataArray objectAtIndex:indexPath.item] coverimg]]];
    
        
        //    NSLog(@"%@",[[self.dataArray objectAtIndex:indexPath.item] title]);
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count>0) {
        
        RadioListViewController *list = [[RadioListViewController alloc] init];
        list.radio = [self.dataArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:list animated:YES];
    }

    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //可滚动区域
    CGFloat contentsizeH = scrollView.contentSize.height - _collectV.bounds.size.height;
//    NSLog(@"contentsizeH=%f",contentsizeH);
    //上拉到底部的高度
    self.conentOffsetY = scrollView.contentOffset.y - contentsizeH;
//    NSLog(@"------->%f",_conentOffsetY);
    if (_conentOffsetY >-720+64 && !self.isrefresh) {
        
        _number = _number+10;
        [self requestMore];
        NSLog(@"加载更多------");
        self.isrefresh = YES;

    }
}

-(void)requestMore
{
   
     [LBProgressHUD showHUDto:self.view animated:YES];//开始菊花
    
    NSString *str1 = @"http://api2.pianke.me/ting/radio_list";
    
    NSURL *url1 = [NSURL URLWithString:str1];
    
    NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:url1];
    request1.HTTPMethod  = @"POST";
    //添加请求体 (请求体是一个NSData 我们用post的目的是想保留一部分数据 我们将这部分数转化成NSData类型 放入请求体中)
    NSString *body1 = [NSString stringWithFormat:@"auth=XZU7RH7m1861DC8Z8H8HvkTJxQMGoPLGO9zo4XDA0cWP22NdFSh9d7fo&client=1&deviceid=6D4DD967-5EB2-40E2-A202-37E64F3BEA31&limit=%ld&start=1&version=4.0.4",_number];
    request1.HTTPBody = [body1 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session1 = [NSURLSession sharedSession];
    //任务
    NSURLSessionTask *task = [session1 dataTaskWithRequest:request1 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [_dataArray removeAllObjects];
        if (data) {
            self.isrefresh = NO;
            //取数据
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *datadic = [dic objectForKey:@"data"];
            NSArray *listArr = [datadic objectForKey:@"list"];
                if (!_dataArray) {
                self.dataArray = [NSMutableArray array];
                }
            for (NSDictionary *dic in listArr) {
                RadioModel *radio = [[RadioModel alloc] init];
                [radio setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:radio];
//              NSLog(@"-------->%@",radio.radioid);
                
            }
            
            NSLog(@"%ld",self.dataArray.count);
            NSLog(@"%@",[[self.dataArray objectAtIndex:0] title]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            [self.collectV reloadData];
                
                [self performSelector:@selector(removeAct) withObject:nil afterDelay:0.2];//停止菊花
                
            [_collectV.mj_header endRefreshing];
                static BOOL b = YES;
                if (b) {
                    _collectV.contentOffset = CGPointMake(0, 0);
                    b = NO;
                }
                

            });
        }else{
             dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(removeAct) withObject:nil afterDelay:0.2];//停止菊花
                 //提示框
                 WarnLabel *warnLab = [WarnLabel creatWarnLabelWithY:200+64 withSuperView:self.view];
                 warnLab.text = @"网络请求失败";
            NSLog(@"%@",error);
             });
        }
    }];
    //启动
    [task resume];
}
-(void)removeAct
{
    [LBProgressHUD hideAllHUDsForView:self.view animated:YES];//停止菊花
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
