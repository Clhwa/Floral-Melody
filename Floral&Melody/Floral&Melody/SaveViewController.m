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

@property(nonatomic,strong)NSMutableArray *deleteArr;//删除数组
@property(nonatomic,strong)UIButton *allSelectbutton;
@property(nonatomic,assign)BOOL isAllSelect;
@property(nonatomic,strong)UIButton *deleteButton;
@end

@implementation SaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self creatTableView];
    [self creatTitleLabel];
//    NSLog(@"%@",[_BigArrayS objectAtIndex:_flag]);
    if ([[_BigArrayS objectAtIndex:_flag] count]==0) {
        [self creatLabel];
    }
    
    //删除按钮
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteCollection:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
    deleteButton.frame = CGRectMake(self.view.bounds.size.width-30-20, 25, 30, 20);
    [self.view addSubview:deleteButton];
    
    self.tableV.allowsMultipleSelectionDuringEditing = YES;
}
#pragma mark-数组懒加载
-(NSMutableArray *)deleteArr
{
    if (!_deleteArr) {
        _deleteArr = [NSMutableArray array];
    }
   return _deleteArr;
}
#pragma mark-删除
-(void)deleteCollection:(UIButton *)deleteButton
{
    if (_deleteArr.count>0) {
        [_deleteArr removeAllObjects];
    }
    [self.tableV setEditing:YES animated:YES];
    
    [deleteButton setTitle:@"取消" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    //弹出全选和删除
    [self createAllselectButton];
}
#pragma mark-全选按钮
-(void)createAllselectButton
{
    CGRect rect = self.tableV.frame;
    rect.size.height = rect.size.height-50;
    [UIView animateWithDuration:0.5 animations:^{
        self.tableV.frame = rect;
        self.allSelectbutton.transform = CGAffineTransformMakeTranslation(0, -40);
        self.deleteButton.transform = CGAffineTransformMakeTranslation(0, -40);
    }];
    
}
#pragma mark-执行删除的按钮的懒加载
-(UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-20-(self.view.bounds.size.width-60)/2, self.view.bounds.size.height, (self.view.bounds.size.width-60)/2, 30)];
        _deleteButton.layer.cornerRadius = 5;
        _deleteButton.layer.masksToBounds = YES;
        _deleteButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _deleteButton.layer.borderWidth = 1;
        [self.view addSubview:_deleteButton];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteSelectArr) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}
#pragma mark-执行删除的按钮
-(void)deleteSelectArr
{
    for (JJTableViewCell *cell in self.deleteArr) {
    NSIndexPath *indexPath = [self.tableV indexPathForCell:cell];
        NSLog(@"%@",cell.titleLabel.text);
        [[_BigArrayS objectAtIndex:_flag]removeObjectAtIndex:indexPath.row];
        [self.tableV deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //从数据库中删除
        
    }
    [self.deleteArr removeAllObjects];

}
#pragma mark-从数据库中删除
-(void)deleteFromSql
{
    if (_flag == 2) {
        //百科
//        [[DataBaseUtil shareDataBase]deleteObjectWithTableName:@"baike" withTextName:@"url" withValue:_list.url];//获取model
    }

}
#pragma mark-全选按钮懒加载
-(UIButton *)allSelectbutton
{
    if (!_allSelectbutton) {
        _allSelectbutton = [[UIButton alloc]initWithFrame:CGRectMake(20, self.view.bounds.size.height, (self.view.bounds.size.width-60)/2, 30)];
        _allSelectbutton.layer.cornerRadius = 5;
        _allSelectbutton.layer.masksToBounds = YES;
        _allSelectbutton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _allSelectbutton.layer.borderWidth = 1;
        [_allSelectbutton setTitle:@"全选" forState:UIControlStateNormal];
        [_allSelectbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_allSelectbutton addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
        _isAllSelect = YES;
        [self.view addSubview:_allSelectbutton];
    }
    return _allSelectbutton;
}
#pragma mark-全选
-(void)allSelect:(UIButton *)but
{
    if (self.deleteArr.count>0) {
        [self.deleteArr removeAllObjects];
    }
    NSArray *arr = [_BigArrayS objectAtIndex:_flag];
    for (int i = 0; i<arr.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.tableV cellForRowAtIndexPath:indexPath];
        if (_isAllSelect) {
            [self.tableV selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
            
            [self.deleteArr addObject:cell];
        }else{
            [self.tableV deselectRowAtIndexPath:indexPath animated:YES];
            
        }
        
    }
    if (_isAllSelect) {
        [_allSelectbutton setTitle:@"清空" forState:UIControlStateNormal];
    }else{
        [_allSelectbutton setTitle:@"全选" forState:UIControlStateNormal];
    }
    
    _isAllSelect = !_isAllSelect;
    
    
    
}
#pragma mark-取消
//取消
-(void)cancel:(UIButton *)deleteButton
{
    
    [self.tableV setEditing:NO animated:YES];
    
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteCollection:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect rect = self.tableV.frame;
    rect.size.height = rect.size.height+50;
    [UIView animateWithDuration:0.5 animations:^{
        self.tableV.frame = rect;
        self.allSelectbutton.transform = CGAffineTransformIdentity;
        self.deleteButton.transform = CGAffineTransformIdentity;
    }];
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
            XLHSpecialModal *list = _BigArrayS[_flag][indexPath.row];
            _cell.titleLabel.text = list.title;
            _cell.subTitle.text = list.content;
            [_cell.imageV sd_setImageWithURL:[NSURL URLWithString:list.Image]];
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
            _cell.subTitle.text = list.Text;
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
#pragma mark-点击取消
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableV.editing) {
        JJTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.deleteArr removeObject:cell];
    }
}
#pragma mark-点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    //判断是否删除
    if (self.tableV.editing) {
         JJTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.deleteArr addObject:cell];
    }else{
    switch (_flag) {
        case 0:{
            //文章
            XLHColumnViewController *column = [[XLHColumnViewController alloc]init];
            XLHSpecialModal *list = _BigArrayS[_flag][indexPath.row];
            column.xlh = list;
            
            
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
