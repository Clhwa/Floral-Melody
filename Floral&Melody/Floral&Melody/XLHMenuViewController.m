//
//  XLHMenuViewController.m
//  Floral&Melody
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHMenuViewController.h"

@interface XLHMenuViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSArray * dataArray;
    UIToolbar *visualView;
    NSArray * apiArray;
}

@end

@implementation XLHMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    
    [self createBackImageView];
    
    [self createTableView];
    
    [self createFloralMelody];
    
    dataArray = @[@"- 家居庭院 -",@"- 缤纷小物 -",@"- 植物百科 -",@"- 花田秘籍 -",@"- 跨界鉴赏 -",@"- 城市微光 -"];
    
    apiArray = @[
        @"http://m.htxq.net/servlet/SysArticleServlet?action=mainList&cateId=79eb0990-3cfd-4d6f-aabd-93ba001d0076&currentPageIndex=%ld&pageSize=%ld",
        @"http://m.htxq.net/servlet/SysArticleServlet?action=mainList&cateId=ef590bfe-47f2-11e5-a94d-f0def1b6f49e&currentPageIndex=%ld&pageSize=%ld",
        @"http://m.htxq.net/servlet/SysArticleServlet?action=mainList&cateId=1fe2ea84-ea8e-45bc-addf-75c0a4451b63&currentPageIndex=%ld&pageSize=%ld",
        @"http://m.htxq.net/servlet/SysArticleServlet?action=mainList&cateId=a56aa5d0-aa6b-42b7-967d-59b77771e6eb&currentPageIndex=%ld&pageSize=%ld",
        @"http://m.htxq.net/servlet/SysArticleServlet?action=mainList&cateId=8e665b7f-2bf5-466e-993b-feca8f39db56&currentPageIndex=%ld&pageSize=%ld",
        @"http://m.htxq.net/servlet/SysArticleServlet?action=mainList&cateId=a9b9bb7f-3b50-4291-9706-05c69742a32f&currentPageIndex=%ld&pageSize=%ld"];
}

/** create the backImageView **/
- (void)createBackImageView
{
    visualView = [[UIToolbar alloc]init];
    visualView.barStyle = UIBarStyleDefault;
    visualView.backgroundColor = [UIColor grayColor];
    visualView.alpha = 0.6;
    visualView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:visualView];
}

/** create tableView **/
- (void)createTableView
{
    /*
     * 创建tableView
     */
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 104 - SCREEN_HEIGHT / 7) style:UITableViewStylePlain];
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
//    _tableView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:_tableView];
}

/*
 * cell的个数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

/*
 * cell的设置
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    XLHSpecialMenuTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XLHSpecialMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.titleLabel.text = [dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

/*
 * cell的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREEN_HEIGHT - 64) / 8;
}

/** touch cell **/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLHFlowerViewController * xlh = [[XLHFlowerViewController alloc] init];
    
    xlh.API = [apiArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:xlh animated:YES];
    
    NSLog(@"11");
}

/** Floral&Melody*/
- (void)createFloralMelody
{
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.81, SCREEN_WIDTH, 1 )];
    lineView.backgroundColor = COLOR(77, 77, 77, 1);
    [self.view addSubview:lineView];
    
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
@end
