//
//  SaveViewController.m
//  Floral&Melody
//
//  Created by lanou on 16/5/12.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "SaveViewController.h"
#import "JJTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "PlayerViewController.h"

#import "RadioViewController.h"
#import "VideoPlayerViewController.h"
#import "XLHSpecialModal.h"
#import "DetailViewController.h"
#import "XLHColumnViewController.h"

@interface SaveViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableV;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)JJTableViewCell *cell;


@end

@implementation SaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self creatTableView];
    [self creatTitleLabel];
//    NSLog(@"%@",[_BigArrayS objectAtIndex:_flag]);
    NSLog(@"%ld",_flag);
    if ([[_BigArrayS objectAtIndex:_flag] count]==0) {
        [self creatLabel];
    }
    
    
}
-(void)creatLabel
{

    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 200, 200, 60)];
    [self.view addSubview:la];
    la.numberOfLines = 2;
    la.textAlignment = NSTextAlignmentCenter;
    la.text = @"亲,你的收藏夹还没有内容哦!赶快去收藏吧!!";


}
-(void)creatTitleLabel
{
    //标题
    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, 20, 200, 30)];
    [self.view addSubview:_titleLable];
    _titleLable.textAlignment =NSTextAlignmentCenter;
    _titleLable.text = [self.TitleArr[_flag] stringByAppendingString:@"收藏"];
    _titleLable.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:18];

    
    //返回按钮
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(20, 25, 20, 20);
    [self.view addSubview:back];
    [back setImage:[UIImage imageNamed:@"com_taobao_tae_sdk_web_view_title_bar_back.9"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(jumpBack) forControlEvents:UIControlEventTouchDown];
    
    

}
-(void)creatTableView
{
    
    //tableView
    self.tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    self.tableV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableV];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}

#pragma -mark UITableView 的代理方法
//row个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_BigArrayS objectAtIndex:_flag] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"cell";
    _cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (_cell == nil) {
        
        _cell = [[JJTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    switch (_flag) {
        case 0:{
            ListContent *list = _BigArrayS[_flag][indexPath.row];
            _cell.titleLabel.text = list.Name;
            _cell.subTitle.text = list.url;
            [_cell.imageV sd_setImageWithURL:[NSURL URLWithString:list.ImageUrl]];
        }
            break;
        case 1:{
            XLHSpecialModal *list = _BigArrayS[_flag][indexPath.row];
            _cell.titleLabel.text = list.title;
            _cell.subTitle.text = list.content;
            [_cell.imageV sd_setImageWithURL:[NSURL URLWithString:list.Image]];
        }
            break;
        case 2:{
            ListContent *list = _BigArrayS[_flag][indexPath.row];
            _cell.titleLabel.text = list.Name;
            _cell.subTitle.text = list.url;
            [_cell.imageV sd_setImageWithURL:[NSURL URLWithString:list.ImageUrl]];
        }
            break;
        case 3:{
        RadioListModel *mo = [[_BigArrayS objectAtIndex:_flag] objectAtIndex:indexPath.row];
        _cell.titleLabel.text = mo.longTitle;
        _cell.subTitle.text = mo.uname;
            
        [_cell.imageV sd_setImageWithURL:[NSURL URLWithString:mo.coverimg]];
//        NSLog(@"%@",mo.uname);

                    }
            break;
            
        default:
            break;
    }
    
    
    
    return _cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    
    switch (_flag) {
        case 0:{
            //文章
            XLHColumnViewController *column = [[XLHColumnViewController alloc]init];
            ListContent *list = _BigArrayS[_flag][indexPath.row];
            column.imageUrl = list.ImageUrl;
            column.urlAddress = list.url;
            column.titleStr = list.Name;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:column];
            [self presentViewController:nav animated:YES completion:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"kAddLeftButtonWithColumn" object:self userInfo:nil];
            }];

        }
            break;
        case 1:{
            VideoPlayerViewController *Video = [[VideoPlayerViewController alloc] init];
            Video.model = _BigArrayS[_flag][indexPath.row];;
            
            Video.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:Video animated:YES completion:^{
                
            }];

            
        }
            break;
        case 2:{
            //百科
            DetailViewController *detail = [[DetailViewController alloc]init];
            ListContent *list = _BigArrayS[_flag][indexPath.row];
            detail.list = list;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:detail];
            [self presentViewController:nav animated:YES completion:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"kAddLeftButton" object:self userInfo:nil];
            }];
        }
            break;
        case 3:{
            PlayerViewController  *play = [[PlayerViewController alloc] init];
            play.musicArray = [_BigArrayS objectAtIndex:_flag];
            play.currentIndex = indexPath.row;
            play.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:play animated:YES completion:^{
            
            }];
        }
            break;
            
        default:
            break;
    }

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
