//
//  FindViewController.m
//  Flower&Melody
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 BF. All rights reserved.
//

#import "FindViewController.h"
#import "NetworkRequestManager.h"
#import "BFCollectionViewCell.h"
#import "BFCollectionReusableView.h"
#import "Type.h"
#import "Content.h"
#import "UIImageView+WebCache.h"
#import "ListViewController.h"
#import "MJRefresh.h"
#import "WarnLabel.h"
#import "SearchView.h"
#import "WarnEnableEmptyLabel.h"
#define WIDTH self.view.frame.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define SPACE 20
#define EDG 10
#define myCenterY 200
@interface FindViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)SearchView *s;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIActivityIndicatorView *act;
@property(nonatomic,strong)UICollectionView *collect;
@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"百科";

    
    [self loadData];
    
    


    
    // Do any additional setup after loading the view.
}

#pragma mark-搜索
-(void)search
{
    ListViewController *list = [[ListViewController alloc]init];
    list.isSeek = YES;
    list.searchName = self.s.tf.text;
    list.title = @"搜查结果";
    [_s appearOrNot];
    _s.hidden = YES;
    [self.navigationController pushViewController:list animated:YES];
    
}
#pragma makr-屏幕出现
-(void)viewDidAppear:(BOOL)animated
{
    _s.hidden = NO;
}


#pragma mark-cell
//cell数量
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    Type *type = _dataArray[section];
    return type.Content.count;
}
//cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    Type *type = self.dataArray[indexPath.section];
    Content *content = type.contentArr[indexPath.item];
    cell.label.text = content.TypeName;
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:content.ImageUrl]];
    return cell;

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ListViewController *list = [[ListViewController alloc]init];
    Type *type = self.dataArray[indexPath.section];
    list.type = type.TypeId;
    Content *content = type.contentArr[indexPath.item];
    list.typeId = content.TypeId;
    list.title = content.TypeName;
    list.isSeek = NO;
    _s.hidden = YES;
    [self.navigationController pushViewController:list animated:YES];
}
//分区数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataArray.count;
}
//自定义分区(分区样子)
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        BFCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        Type *type = _dataArray[indexPath.section];
        headerView.titleLab.text = type.TypeName;
        return headerView;
    }
    return nil;
}
//分区的高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(_collect.frame.size.width, 40);
}
#pragma mark- 请求数据
-(void)loadData
{
    [self.act startAnimating];//菊花
    [NetworkRequestManager createPostRequestWithUrl:@"http://101.200.141.66:8080/EncyclopediaCategory" withBody:nil finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic);
        if ([[dic objectForKey:@"Code"]integerValue]==1) {
        NSArray *dataArray = [dic objectForKey:@"Data"];
        for (NSDictionary *dic1 in dataArray) {
            Type *type = [[Type alloc]init];
            [type setValueWith:dic1];
            [self.dataArray addObject:type];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collect reloadData];
            [self.act stopAnimating];
            //添加搜索框
            _s = [[SearchView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64) withSearchBlock:^{
                if (_s.tf.text.length == 0) {
                    WarnEnableEmptyLabel *warnLabel = [[WarnEnableEmptyLabel alloc]initWithFrame:CGRectMake(_s.tf.frame.origin.x-10, 64+10, 180, 35) withSuperView:self.navigationController.view withText:@"搜索内容不能为空哟"];
                    warnLabel.textColor = [UIColor cyanColor];
                }else{
                  [self search];
                }
               
            } withSuperView:self.navigationController.view];
        });
            
        }
    } error:^(NSError *error) {
        //返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
        WarnLabel *warnLab = [WarnLabel creatWarnLabelWithY:myCenterY withSuperView:self.view];
        warnLab.text = @"网络请求失败";
        [self.act stopAnimating];
            //再次请求数据
            [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
            });
    }];
}

#pragma mark-懒加载
-(UICollectionView *)collect
{
    if (!_collect) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        //边距
        CGFloat w = (WIDTH - 5*SPACE)/4;
        layout.itemSize = CGSizeMake(w, w+30);
        layout.minimumInteritemSpacing = SPACE;
        layout.minimumLineSpacing = SPACE;
        layout.sectionInset = UIEdgeInsetsMake(EDG, SPACE, EDG, SPACE);
        
        _collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49) collectionViewLayout:layout];
        _collect.backgroundColor =[UIColor whiteColor];
        [self.view addSubview:_collect];
        _collect.delegate = self;
        _collect.dataSource = self;
        //注册
        [_collect registerClass:[BFCollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
        //注册分区头
        [_collect registerClass:[BFCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }
    return _collect;
}
-(UIActivityIndicatorView *)act
{
    if (!_act) {
        _act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:_act];
        _act.center = CGPointMake(self.view.frame.size.width/2, myCenterY);
        _act.color = [UIColor lightGrayColor];
    }
    return _act;
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
