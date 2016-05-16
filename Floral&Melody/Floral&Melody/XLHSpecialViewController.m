//
//  XLHSpecialViewController.m
//  Floral&Melody
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHSpecialViewController.h"

#import "MJRefresh.h"

#import "UIImageView+WebCache.h"

#import "AFNetworking.h"

#import "WarnLabel.h"
#import "DataBaseUtil.h"
#import "LBProgressHUD.h"

static NSString * ID = @"cell";



//-----------------------------------------------------------------------------------------------------------------------
@interface SDWebImageManager  (cache)

- (BOOL)memoryCachedImageExistsForURL:(NSURL *)url;

@end

@implementation SDWebImageManager (cache)

- (BOOL)memoryCachedImageExistsForURL:(NSURL *)url {
    NSString *key = [self cacheKeyForURL:url];
    return ([self.imageCache imageFromMemoryCacheForKey:key] != nil) ?  YES : NO;
}

@end
//-----------------------------------------------------------------------------------------------------------------------

@interface XLHSpecialViewController ()<UIGestureRecognizerDelegate>
{
    UIButton * SpecialButton;
    NSInteger pageNumber;
    NSInteger pageSize;
    UIView * grayView;
    
}
@end

@implementation XLHSpecialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tableview设置
    [self SettingOfTableView];
    //初始化常量
    [self initColumn];
    //请求数据
    [self requestData];
    //mjrefresh设置
    [self createMJRefresh];
    //弹出小窗口
    [self createNavigationBar];
    //注册通知跳转页面
    [self registerNotification];

    //数据库
    [[DataBaseUtil shareDataBase]createTableWithName:@"article" withTextArray:@[@"title",@"pageUrl",@"Image",@"content"]];
    
    /** 打印所有字体*/
//    for(NSString *fontfamilyname in [UIFont familyNames])
//    {
//        NSLog(@"family:'%@'",fontfamilyname);
//        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
//        {
//            NSLog(@"\tfont:'%@'",fontName);
//        }
//        NSLog(@"-------------");
//    }
    
}
#pragma mark - request data

/** 初始化常量*/
- (void)initColumn
{
    pageSize = 5;
    pageNumber = 0;
}
/** 请求数据*/
- (void)requestData
{
     [LBProgressHUD showHUDto:self.view animated:YES];//开始菊花
    
    //初始化manager
    AFHTTPSessionManager * AFManager = [AFHTTPSessionManager manager];
    
    //不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    AFManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //post请求
    [AFManager POST:[NSString stringWithFormat:@"http://m.htxq.net/servlet/SysArticleServlet?action=mainList&currentPageIndex=%ld&pageSize=%ld",pageNumber,pageSize ] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
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
            
            [self performSelector:@selector(removeAct) withObject:nil afterDelay:0.2];//停止菊花
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(removeAct) withObject:nil afterDelay:0.2];//停止菊花
        
        //提示框
        WarnLabel *warnLab = [WarnLabel creatWarnLabelWithY:200+64 withSuperView:self.view];
        warnLab.text = @"专题请求失败";
            });
//        NSLog(@"专题请求失败");
    }];

}
/** update刷新数据 */
- (void)updateRequest
{
     [LBProgressHUD showHUDto:self.view animated:YES];//开始菊花
    
    //初始化manager
    AFHTTPSessionManager * AFManager = [AFHTTPSessionManager manager];
    
    //不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    AFManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //post请求
    [AFManager POST:[NSString stringWithFormat:@"http://m.htxq.net/servlet/SysArticleServlet?action=mainList&currentPageIndex=%d&pageSize=%ld", 0,pageSize] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"专题请求进度");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //获取最外层字典
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        //获取结果数组
        NSArray * resultArray = [dic valueForKey:@"result"];
        
        [_dataArray removeAllObjects];
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
            [self performSelector:@selector(removeAct) withObject:nil afterDelay:0.2];//停止菊花
            
           [self.tableView.mj_header endRefreshing];
            
            [self.tableView reloadData];
            pageNumber = 0;
        });
 
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
       [self performSelector:@selector(removeAct) withObject:nil afterDelay:0.2];//停止菊花
        
        [self.tableView.mj_header endRefreshing];
        //提示框
        WarnLabel *warnLab = [WarnLabel creatWarnLabelWithY:200+64 withSuperView:self.view];
        warnLab.text = @"专题请求失败";
             });
//        NSLog(@"专题请求失败");
    }];

}
/** loadMore*/
- (void)loadMoreRequest
{
     [LBProgressHUD showHUDto:self.view animated:YES];//开始菊花
    
      pageNumber = pageNumber + 1;
    //初始化manager
    AFHTTPSessionManager * AFManager = [AFHTTPSessionManager manager];
    
    //不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    AFManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //post请求
    [AFManager POST:[NSString stringWithFormat:@"http://m.htxq.net/servlet/SysArticleServlet?action=mainList&currentPageIndex=%ld&pageSize=%ld",pageNumber,pageSize ] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
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
            [self performSelector:@selector(removeAct) withObject:nil afterDelay:0.2];//停止菊花
            
            [self.tableView reloadData];
            NSLog(@"%ld",self.dataArray.count);
            [self.tableView.mj_footer endRefreshing];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(removeAct) withObject:nil afterDelay:0.2];//停止菊花
        
        //结束
        [self.tableView.mj_footer endRefreshing];
        //提示
        WarnLabel *warnLab = [WarnLabel creatWarnLabelWithY:[UIScreen mainScreen].bounds.size.height-64-50 withSuperView:self.view];
        warnLab.text = @"专题请求失败";
             });
//        NSLog(@"专题请求失败");
    }];
    
}
-(void)removeAct
{
    [LBProgressHUD hideAllHUDsForView:self.view animated:YES];//停止菊花
    
}


#pragma mark - setting of navigationBar
/** setting of navigationBar **/
- (void)createNavigationBar
{
    [self createSpecialButton];
    [self createMenuButton];
    [self createTOPButton];
    [self XLHMenuVC];
}
/** setting of navigationBar --- Special**/
- (void)createSpecialButton
{
    
    SpecialButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [SpecialButton setFrame:CGRectMake(0, 0, 30, 20)];
    
    [SpecialButton setTitle:@"专题" forState:UIControlStateNormal];
    
    [SpecialButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    SpecialButton.titleLabel.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:16];
    
    [SpecialButton setImage:[UIImage imageNamed:@"arrow - down"] forState:UIControlStateNormal];
    
    [SpecialButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -60, 0, 0)];
    
    [SpecialButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, - 85)];
    
    [SpecialButton addTarget:self action:@selector(TouchSpecialButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationItem setTitleView:SpecialButton];
    
}
/** setting of navigationBar --- Menu**/
- (void)createMenuButton
{
    
    UIButton * MenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [MenuButton setFrame:CGRectMake(0, 0, 21, 24)];

    [MenuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];

    [MenuButton addTarget:self action:@selector(TouchMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:MenuButton];

}
/** setting of navigationBar --- T.O.P**/
- (void)createTOPButton
{
    
    UIButton * TOPButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [TOPButton setFrame:CGRectMake(0, 0, 30, 20)];
    
    [TOPButton setImage:[UIImage imageNamed:@"TOP"] forState:UIControlStateNormal];
    
    [TOPButton addTarget:self action:@selector(TouchTOPButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:TOPButton];
    
}
/** Touch --- Menu **/
- (void)TouchMenuButton:(UIButton *)button
{

    [UIView animateWithDuration:0.2 animations:^{
        
        if (!button.selected) {
                [button setTransform:CGAffineTransformRotate(button.transform, M_PI_2)];

            
            [UIView animateWithDuration:0.1 animations:^{

                [self.view addSubview:self.XLHMenuVC.view];
            }];
            
            [UIView animateWithDuration:0.2 animations:^{

                self.XLHMenuVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
            } completion:^(BOOL finished) {
                
            }];
            button.selected = YES;
            
        }else{
            [button setTransform:CGAffineTransformRotate(button.transform, - M_PI_2)];
            [UIView animateWithDuration:0.1 animations:^{
                self.XLHMenuVC.view.frame = CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
            } completion:^(BOOL finished) {
                [self.XLHMenuVC.view removeFromSuperview];
            }];
            button.selected = NO;
        }
    }];
}
/** Touch --- Special **/
- (void)TouchSpecialButton:(UIButton *)button
{
    [UIView animateWithDuration:0.3 animations:^{
        
        if (!button.selected)
        {
            [self showSpecial];
        }
        else
        {
            [self closeSpecial];
        }
    }];

}
/** Touch --- TOP **/
- (void)TouchTOPButton:(UIButton *)button
{
    
    XLHTOPViewController * top = [[XLHTOPViewController alloc] init];
    
    [self.navigationController pushViewController:top animated:YES];

}

#pragma mark - show or close Special
/** show specialMenuView **/
- (void)showSpecial
{
    SpecialButton.imageView.transform = CGAffineTransformRotate(SpecialButton.imageView.transform, - M_PI);
    
    [self.navigationController.view addSubview:self.spaceView];
    
    SpecialButton.selected = YES;
}
- (void)closeSpecial
{
    SpecialButton.imageView.transform = CGAffineTransformRotate(SpecialButton.imageView.transform,  M_PI);
    [self.spaceView removeFromSuperview];
    SpecialButton.selected = NO;
}

#pragma mark - setting of TableView
/** setting of tableView **/
- (void)SettingOfTableView
{
    
    /*
     *  author @西兰花
     *
     *  2016 - 05 - 03
     *
     *  All rights reserved.
     */
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = COLOR(241, 241, 241, 1);
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[XLHColumnTableViewCell class] forCellReuseIdentifier:ID];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view data source
/** Incomplete implementation, return the number of rows **/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
/** Incomplete implementation, return the tableViewCell **/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XLHColumnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    XLHSpecialModal * xlh = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = xlh.title;
    cell.contentLabel.text = xlh.content;
    cell.typeLabel.text = xlh.type;
    cell.userNameLabel.text = xlh.userName;
    cell.identifierLabel.text = xlh.identifier;
    cell.timeLabel.text = xlh.time;
    cell.readerLabel.text =  [NSString stringWithFormat:@"%ld", xlh.reader];
    
    
   
    [cell.ImageView sd_setImageWithURL:[NSURL URLWithString:xlh.Image] placeholderImage:[UIImage imageNamed:@"占位花"] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    [cell.IconImageView sd_setImageWithURL:[NSURL URLWithString:xlh.userIcon] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];

    return cell;
}
/** Incomplete implementation, return the selected cell **/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XLHColumnViewController * column = [[XLHColumnViewController alloc] init];
    
    XLHSpecialModal * xlh = [self.dataArray objectAtIndex:indexPath.row];

    column.xlh = xlh;
    [self.navigationController pushViewController:column animated:YES];
    
}
/** Incomplete implementation, return the height of cell **/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.6;
}
/** Incomplete implementation, display of cell*/
- (void)tableView:(UITableView *)tableView willDisplayCell:(XLHColumnTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XLHSpecialModal * xlh = [self.dataArray objectAtIndex:indexPath.row];
    
    if (![[SDWebImageManager sharedManager] memoryCachedImageExistsForURL:[NSURL URLWithString:xlh.Image]]) {
        [cell animation];
    }
}



#pragma mark - MJRefresh
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
 
    /*
     * footerView --- LoadData *
     */
    
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{

        [self loadMoreRequest];
        
    }];
    
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



#pragma mark - register notification
- (void)registerNotification
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToArticle:) name:@"pushToArticle" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToVideo:) name:@"pushToVideo" object:nil];
}
- (void)pushToArticle:(NSNotification *)notification
{
    
    [self closeSpecial];
    
    XLHArticleViewController * art = [[XLHArticleViewController alloc] init];
    
    [self.navigationController pushViewController:art animated:YES];
    
    
}
- (void)pushToVideo:(NSNotification *)notification
{
    
    [self closeSpecial];
    
    XLHVideoViewController * video = [[XLHVideoViewController alloc] init];
    
    [self.navigationController pushViewController:video animated:YES];
}

#pragma mark - Lazy
/** judge XLHMenuVC exist or not --- lazy **/
- (XLHMenuViewController *)XLHMenuVC
{
    if (!_XLHMenuVC) {
        _XLHMenuVC = [[XLHMenuViewController alloc] init];
        
        [self addChildViewController:_XLHMenuVC];
        
        _XLHMenuVC.view.frame = CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    };
    return _XLHMenuVC;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (BFMenuView *)BFMenuView
{
    if (!_BFMenuView) {
        _BFMenuView = [[BFMenuView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 40, 62, 95, 75) withRadius:5 withTriangleLenth:15 withHeight:10 MenuWithTitleItems:@[@"文章",@"视频"] IconItems:nil];
    }
    return _BFMenuView;
}
- (UIView *)spaceView
{
    if (!_spaceView) {
        _spaceView = [[UIView alloc] initWithFrame:self.view.bounds];
        
        [_spaceView addSubview:self.BFMenuView];
        
        _spaceView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSpaceView:)];
        tap.delegate = self;
        [_spaceView addGestureRecognizer:tap];
    }
    return _spaceView;
}
- (void)cancelSpaceView:(UITapGestureRecognizer *)tap
{
    [self closeSpecial];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
//    NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    
    return  YES;
}
@end