//
//  SaveViewController.m
//  Floral&Melody
//
//  Created by lanou on 16/5/12.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "SaveViewController.h"
#import "JJTableViewCell.h"
@interface SaveViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableV;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation SaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(20, 25, 20, 20);
    [self.view addSubview:back];
    [back setImage:[UIImage imageNamed:@"com_taobao_tae_sdk_web_view_title_bar_back.9"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(jumpBack) forControlEvents:UIControlEventTouchDown];
    
    
    [self creatTableView];
    
    
    
    
    
}
-(void)creatTableView
{
    
    //tableView
    self.tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height-30)];
    self.tableV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableV];
    _tableV.delegate = self;
    _tableV.dataSource = self;
//    _tableV.separatorStyle = UITableViewRowAnimationNone;
    
}

#pragma -mark UITableView 的代理方法
//row个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"cell";
    JJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[JJTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       NSLog(@"%ld",indexPath.section);
    
}

-(void)jumpBack
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
