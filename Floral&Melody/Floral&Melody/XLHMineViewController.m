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
#import "RadioListModel.h"
#import "DataBaseUtil.h"
@interface XLHMineViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)NSInteger flag;
@property(nonatomic,strong)NSArray *Images;
@property(nonatomic,strong)NSArray *Title;
@property(nonatomic,strong)NSMutableArray *Content;
@property(nonatomic,strong)UITableView *tableV;

@property(nonatomic,strong)NSMutableArray *BigArray;
@property(nonatomic,strong)NSArray *articleArr;
@property(nonatomic,strong)NSArray *VideoArr;
@property(nonatomic,strong)NSArray *BaikeArr;
@property(nonatomic,strong)NSArray *RadioArr;

@end

@implementation XLHMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatColletionView];
    [self initTableView];
    _Images = [NSArray arrayWithObjects:[UIImage imageNamed:@"one"], [UIImage imageNamed:@"two"],[UIImage imageNamed:@"three"],[UIImage imageNamed:@"four"],nil];
   self.Title = [NSMutableArray arrayWithObjects:@"文章",@"视频",@"百科",@"电台", nil];
    self.Content = [NSMutableArray arrayWithObjects:@"关于应用", @"关注我们",@"版权声明",@"清理缓存",@"当前版本     V1.0.1",nil];
    
    [self createFloralMelody];
    
    
    
   
    
    //设置主题
    [self setViewControllerTitleWith:@"我的"];
}
#pragma mark-主题
-(void)setViewControllerTitleWith:(NSString *)title
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-64*2, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:18];
    self.navigationItem.titleView = label;
}

-(void)getDataArray{
    
    _RadioArr = [[DataBaseUtil shareDataBase] selectTable:@"RadioSave" withClassName:@"RadioListModel" withtextArray:@[@"coverimg",@"musicUrl",@"webview_url",@"uname",@"longTitle",@"title"] withList:nil withYouWantSearchContent:nil];
    
    _VideoArr = [[DataBaseUtil shareDataBase]selectTable:@"video" withClassName:@"XLHSpecialModal" withtextArray:@[@"Image",@"title",@"content",@"videoUrl"] withList:nil withYouWantSearchContent:nil];

    _BaikeArr = [[DataBaseUtil shareDataBase] selectTable:@"baike" withClassName:@"ListContent" withtextArray:@[@"Name",@"url",@"ImageUrl"] withList:nil withYouWantSearchContent:nil];

    _articleArr = [[DataBaseUtil shareDataBase] selectTable:@"article" withClassName:@"ListContent" withtextArray:@[@"Name",@"url",@"ImageUrl"] withList:nil withYouWantSearchContent:nil];

    
#warning 自行补充各自的数据
/*
 
 自行补充各自的数据;

 */
    
    _BigArray = [NSMutableArray array];
    
    
    [self.BigArray addObject:_articleArr];
    [self.BigArray addObject:_VideoArr];
    [self.BigArray addObject:_BaikeArr];
    [self.BigArray addObject:_RadioArr];

}

- (void)createFloralMelody
{
//    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.81, SCREEN_WIDTH, 1 )];
//    lineView.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:lineView];
    
    UILabel * engLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.83, SCREEN_WIDTH, SCREEN_HEIGHT * 0.03)];
    [self.view addSubview:engLabel];
    engLabel.text = @"Floral&Melody";
    engLabel.textAlignment = 1;
    [engLabel setTextColor:[UIColor blackColor]];
    [engLabel setFont:[UIFont systemFontOfSize:13]];
    
    UILabel * chineseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.88, SCREEN_WIDTH, SCREEN_HEIGHT * 0.03)];
    [self.view addSubview:chineseLabel];
    chineseLabel.text = @"- 花の旋律 -";
    chineseLabel.textAlignment = 1;
    [chineseLabel setTextColor:[UIColor blackColor]];
    [chineseLabel setFont:[UIFont systemFontOfSize:13]];
    
    
}

-(void)initTableView
{
    _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 210, Kwidth,400)];
    [self.view addSubview: _tableV];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.showsVerticalScrollIndicator = NO;
    _tableV.separatorStyle = UITableViewCellAccessoryNone;
    _tableV.scrollEnabled = NO;
    

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
#pragma -mark viewWillAppear
- (void)viewWillAppear:(BOOL)animated{
    [self displayTmpPics];
    [self getDataArray];
    
}

- (void)clearTmpPics{
    [[SDImageCache sharedImageCache] clearDisk];
    [self displayTmpPics];
}
//显示，并删除图片缓存部分*******************************************************
#pragma mark 显示缓存量
- (void)displayTmpPics{
    float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
    
    NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存     %.2fM",tmpSize] : [NSString stringWithFormat:@"清理缓存     %.2fK",tmpSize * 1024];
    
    
    [self.Content replaceObjectAtIndex:3 withObject:clearCacheName];
    
    NSIndexSet *indexS = [[NSIndexSet alloc] initWithIndex:3];
    [self.tableV reloadSections:indexS withRowAnimation:UITableViewRowAnimationNone];
    
}

// 询问用户是否删除缓存
- (void)alertForCleanCache{
    
    UIAlertController *AlertC = [UIAlertController alertControllerWithTitle:@"是否清除缓存？"message:@"清除后，手机容量得到释放。但所有页面的图片需要重新加载，非WiFi网络下要消耗流量，真的要清除吗？"preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleDefault
    handler:^(UIAlertAction *action){
        }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction *action){[self clearTmpPics];
        }];
    
    [AlertC addAction:okAction];
    [AlertC addAction:cancelAction];
    
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:AlertC animated:YES completion:nil];
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
    return 5;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        return 10;
    }
    return 0;
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
    switch (indexPath.section) {
        case 0:{
        
        }
        break;
        case 1:{
            
        }
            break;
        case 2:{
            
        }
            break;
        case 3:{
            [self alertForCleanCache];

        }
            break;
            
        default:
            break;
    }
    NSLog(@"%ld",indexPath.section);

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
    
//    cell.content.text = @"333内容";
    cell.content.text = [NSString stringWithFormat:@"%ld内容",[[_BigArray objectAtIndex:indexPath.item] count]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SaveViewController *save = [[SaveViewController alloc] init];
    save.BigArrayS = self.BigArray;
    save.TitleArr = self.Title;
    save.flag = indexPath.item;
    
    
    save.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:save animated:YES completion:^{

    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
