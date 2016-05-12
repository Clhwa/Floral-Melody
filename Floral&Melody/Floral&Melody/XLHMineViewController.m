//
//  XLHMineViewController.m
//  Floral&Melody
//
//  Created by lanou on 16/5/10.
//  Copyright © 2016年 西兰花. All rights reserved.
//
#define Kwidth self.view.bounds.size.width
#define KHeight self.view.bounds.size.height
#import "SaveViewController.h"
#import "XLHMineViewController.h"
#import "JJCollectionViewCell.h"

@interface XLHMineViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)NSInteger flag;
@property(nonatomic,strong)NSArray *Images;
@property(nonatomic,strong)NSArray *Title;
@property(nonatomic,strong)NSArray *Content;
@end

@implementation XLHMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.navigationController.navigationBarHidden = YES;
    
//       self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self creatColletionView];
    [self initTableView];
    _Images = [NSArray arrayWithObjects:[UIImage imageNamed:@"one"], [UIImage imageNamed:@"two"],[UIImage imageNamed:@"three"],[UIImage imageNamed:@"four"],nil];
   self.Title = [NSArray arrayWithObjects:@"文章",@"视频",@"百科",@"电台", nil];
    self.Content = [NSArray arrayWithObjects:@"关于花千谷",@"清除缓存",@"意见反馈", @"关注我们",@"当前版本  1.0.1",@"版权声明",nil];
    
    
    
}
-(void)initTableView
{
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, Kwidth,400)];
    [self.view addSubview: tableV];
    tableV.delegate = self;
    tableV.dataSource = self;

}
-(void)creatColletionView
{

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(Kwidth/5,Kwidth/5+60);
    flowLayout.minimumLineSpacing = 10;//行
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Kwidth, KHeight-49-200) collectionViewLayout:flowLayout];
    [self.view addSubview:collection];
    
    collection.dataSource = self;
    collection.delegate = self;
    collection.backgroundColor = [UIColor whiteColor];
    
    //注册cell
    [collection registerClass:[JJCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];


}


#pragma -mark UITableView 的代理方法
//row个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;

}
//分区高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
       
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.detailTextLabel.text = _Content[indexPath.section];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"%ld",indexPath.row);

}
#pragma -mark UICollectionView 的代理方法
//item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

//collectionView的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JJCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageV.image = _Images[indexPath.row];
    cell.title.text = _Title[indexPath.row];
    cell.content.text = @"333";
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SaveViewController *save = [[SaveViewController alloc] init];
    [self.navigationController pushViewController:save animated:YES];
    NSLog(@"你点了第%ld分区的第%ld个方块",indexPath.section,indexPath.item);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
