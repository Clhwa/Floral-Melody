//
//  ListViewController.m
//  Flower&Melody
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 BF. All rights reserved.
//

#import "ListViewController.h"

#import "LBProgressHUD.h"  //菊花
#import "NetworkRequestManager.h"
#import "ListContent.h"
#import "DetailViewController.h"
#import "StickCollectionViewFlowLayout.h"
#import "StickCollectionViewCell.h"

#import "WarnLabel.h"
#import "GoToTopButton.h"
#import "UIImageView+WebCache.h"
#import "XLHMJRefresh.h"
#import "DataBaseUtil.h"
#define WIDTH self.view.frame.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    BOOL isRefresh;
    BOOL b;
}
@property(nonatomic,strong)UILabel *numberLab;
//@property(nonatomic,strong)UIActivityIndicatorView *act;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger number;
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)GoToTopButton *button;
@property(nonatomic,strong)NSString *warnStr;
@property(nonatomic,assign)CGFloat mycenterY;

@end

static const float kCellHeight = 120.f;
static const float kItemSpace = -20.f;
//static const CGFloat kFirstItemTransform = 0.05f;
@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置主题
    [self setViewControllerTitleWith:_titleStr];
    self.view.backgroundColor = [UIColor whiteColor];
    
        [self refresh];
    
    //创建数据库
    [[DataBaseUtil shareDataBase]createTableWithName:@"baike" withTextArray:@[@"Name",@"url",@"ImageUrl",@"Text"]];
    
    // Do any additional setup after loading the view.
    
    [self creatBackButton];

}
-(void)creatBackButton
{
    
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(20, 25, 23, 23);
    [backButton setImage:[UIImage imageNamed:@"com_taobao_tae_sdk_web_view_title_bar_back.9"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(jumpBack) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}
//返回按钮的方法
-(void)jumpBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-屏幕出现
-(void)viewDidAppear:(BOOL)animated
{
    if (!b) {
        b = YES;
    }else{
        [UIView animateWithDuration:0.15 animations:^{
            _collectionView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-49+64);
        }];
        
    }
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
#pragma mark-滚动后出现
-(void)appearCollectButton
{
    [UIView animateWithDuration:0.3 animations:^{
        self.button.alpha = 0.6;
    }];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self appearCollectButton];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self appearCollectButton];
}

#pragma mark-滚动隐藏
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![self.view.subviews containsObject:self.button]) {
        [self.view addSubview:self.button];
    }
    if (self.button.alpha != 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.button.alpha = 0;
        }];
    }
}
#pragma mark-搜索页面数据
-(void)seekViewLoadData
{
    
    [NetworkRequestManager createPostRequestWithUrl:@"http://101.200.141.66:8080/SearchEncyclopedia" withBody:[NSString stringWithFormat:@"Name=%@&Page=%%7B%%22PageNo%%22%%3A%ld%%2C%%22Size%%22%%3A10%%7D&UserId=&",_searchName,_page] finish:^(NSData *data) {
        [self analyzingData:data];

        
    } error:^(NSError *error) {
        [self falseToRequestData];
        
    }];

}

#pragma mark-tableView
-(void)addTableView
{
    [self.view addSubview:self.collectionView];
    
    MJRefreshNormalHeader * header = [[XLHMJRefresh shareXLHMJRefresh] header];
    header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _collectionView.mj_header = header;
    
    MJRefreshAutoNormalFooter * footer = [[XLHMJRefresh shareXLHMJRefresh] footer];
    footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    _collectionView.mj_footer = footer;

    
}
#pragma mark-判断加载哪个URL
-(void)jugeWhichURLToloadData
{
    //菊花
//    [self.act startAnimating];
    [LBProgressHUD showHUDto:self.view animated:YES];//开始菊花
    if (_isSeek) {
        [self seekViewLoadData];
    }else{
        [self loadData];
    }
}
#pragma mark-刷新
-(void)refresh
{
    _warnStr = @"加载成功";
    _mycenterY = 200.0+64;
    isRefresh = YES;
    _page = 1;
    [self jugeWhichURLToloadData];
   
}
#pragma mark-加载更多
-(void)loadMore
{
    _warnStr = @"获取更多成功";
    _mycenterY = HEIGHT-64-50;
    _page++;
   [self jugeWhichURLToloadData];
}
#pragma mark -=CollectionView datasource=-
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StickCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
   ListContent *content = _dataArr[indexPath.row];
    [cell.act startAnimating];
    //开始加载
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:content.ImageUrl] placeholderImage:[UIImage imageNamed:@"占位花"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [cell.act stopAnimating];
    }];

   cell.titleLab.text = content.Name;
    [cell.titleLab sizeToFit];
    cell.textLab.text = content.Text;
    [cell.textLab sizeToFit];
 
    return cell;
}

#pragma mark -=CollectionView layout=-
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.view.bounds), kCellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kItemSpace;
}



#pragma mark-跳转页面
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [[DetailViewController alloc]init];
    ListContent *list = _dataArr[indexPath.item];
    list.url = [NSString stringWithFormat: @"http://101.200.141.66:8080/EncyclopediaDetail?Id=%ld&Type=0",list.Id];
    detail.list = list;
    
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark-刷新数据
-(void)loadData
{
    [NetworkRequestManager createPostRequestWithUrl:@"http://101.200.141.66:8080/EncyclopediaList" withBody:[NSString stringWithFormat:@"UserId=&Type=%ld&Page=%%7B%%22PageNo%%22%%3A%ld%%2C%%22Size%%22%%3A10%%7D&TypeId=%ld",_type,_page,_typeId] finish:^(NSData *data) {
        [self analyzingData:data];
        
    } error:^(NSError *error) {
        [self falseToRequestData];
    }];
}
#pragma mark-请求失败
-(void)falseToRequestData
{
    _warnStr = @"网络请求失败";
    //返回主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.view.subviews containsObject:self.collectionView]){
            [_collectionView.mj_header endRefreshing];
            [_collectionView.mj_footer endRefreshing];
        }
//        [_act stopAnimating];
        [self performSelector:@selector(removeAct) withObject:nil afterDelay:0.2];//停止菊花
        
        WarnLabel *warnLab = [WarnLabel creatWarnLabelWithY:200+64 withSuperView:self.view];
        warnLab.text = _warnStr;
    });
}
-(void)removeAct
{
    [LBProgressHUD hideAllHUDsForView:self.view animated:YES];//停止菊花
    
}
#pragma mark-解析数据成功
-(void)analyzingData:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //        NSLog(@"%@",dic);
    
    if ([[dic objectForKey:@"Code"]integerValue] == 1) {
        NSDictionary *dic1 = [dic objectForKey:@"Data"];
        //判断有数据才执行
        if (dic1.count>0) {
            
            _number = [[dic1 objectForKey:@"Count"]integerValue];
            NSArray *array = [dic1 objectForKey:@"Content"];
            
            if (isRefresh) {
                //用来判断刷新还是加载
                [_dataArr removeAllObjects];
                isRefresh = NO;
            }
            
            for (NSDictionary *dic2 in array) {
                ListContent *content = [[ListContent alloc]init];
                [content setValuesForKeysWithDictionary:dic2];
                [self.dataArr addObject:content];

            }
            
        }else{
            _warnStr = @"没有更多数据了";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (![self.view.subviews containsObject:self.collectionView]) {
                [self addTableView];
            }
            
//            [_act stopAnimating];
            [self performSelector:@selector(removeAct) withObject:nil afterDelay:0.2];//停止菊花
            
            [_collectionView.mj_header endRefreshing];
            [_collectionView.mj_footer endRefreshing];
            
            WarnLabel *warnLab = [WarnLabel creatWarnLabelWithY:_mycenterY withSuperView:self.view];
            warnLab.text = _warnStr;
            
            self.numberLab.text = [NSString stringWithFormat:@"找到%ld种植物",_number];//要返回主线程添加
            [self changeTextColor];//字体改变
            [_collectionView reloadData];
            
            
        });
    }
}
#pragma mark-改变字体颜色
-(void)changeTextColor
{
    NSMutableAttributedString *colorString = [[NSMutableAttributedString alloc]initWithString:self.numberLab.text];
    [colorString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(2, _numberLab.text.length-5)];
    [colorString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Georgia-Italic" size:16] range:NSMakeRange(2, _numberLab.text.length-5)];
    _numberLab.attributedText = colorString;
}
#pragma mark-懒加载
-(GoToTopButton *)button
{
    if (!_button) {
        //置顶
        _button = [[GoToTopButton alloc]initWithFrame:CGRectMake(WIDTH-20-45, HEIGHT-64-20-45, 45, 45) withControlView:_collectionView];
        _button.alpha = 0.6;
    }
    return _button;
}
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        StickCollectionViewFlowLayout *layout = [[StickCollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49) collectionViewLayout:layout];
//        layout.firstItemTransform = kFirstItemTransform;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[StickCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}
-(UILabel *)numberLab
{
    if (!_numberLab) {
        _numberLab = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 130, 20)];
        _numberLab.font = [UIFont systemFontOfSize:12];
        _numberLab.textAlignment = NSTextAlignmentRight;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_numberLab];
    }
    return _numberLab;
}
//-(UIActivityIndicatorView *)act
//{
//    if (!_act) {
//        _act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        [self.view addSubview:_act];
//        _act.center = CGPointMake(self.view.frame.size.width/2, 200);
//        _act.color = [UIColor lightGrayColor];
//    }
//    return _act;
//}
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
