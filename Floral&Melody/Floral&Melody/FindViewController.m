//
//  FindViewController.m
//  Flower&Melody
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 BF. All rights reserved.
//

#import "FindViewController.h"

#import "LBProgressHUD.h" //菊花
#import "NetworkRequestManager.h"

#import "Type.h"
#import "Content.h"
//#import "UIImageView+WebCache.h"
#import "ListViewController.h"
#import "WarnLabel.h"
#import "SearchView.h"
#import "WarnEnableEmptyLabel.h"

#import "DBSphereView.h" //云
#import "DisperseBtn.h" //花叶

#define WIDTH self.view.frame.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define myCenterY 200
@interface FindViewController ()
@property (nonatomic,strong) DBSphereView *sphereView;

@property (strong, nonatomic) DisperseBtn *disView;
@property(nonatomic,strong)SearchView *s;

@property(nonatomic,strong)NSMutableArray *dataArray;
//@property(nonatomic,strong)UIActivityIndicatorView *act;


@property(nonatomic,assign)NSInteger typeId;

@property(nonatomic,strong)UIImageView *imageV;
@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置主题
    [self setViewControllerTitleWith:@"百科"];

    _imageV = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self changeImage];
    _imageV.alpha = 0.6;
    
    //填充
    _imageV.contentMode =  UIViewContentModeScaleAspectFill;

    
    [self.view addSubview:_imageV];

    
    
    [self loadData];
    
    
//定时器
    [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];

    
    // Do any additional setup after loading the view.


}
#pragma mark-定时切换图片
-(void)changeImage
{
    static NSInteger index = 0;
    NSArray *Images = [NSArray arrayWithObjects:[UIImage imageNamed:@"meigui.jpg"],[UIImage imageNamed:@"one"], [UIImage imageNamed:@"qidong_1"],[UIImage imageNamed:@"three"],[UIImage imageNamed:@"four"],nil];
    if (index == Images.count) {
        index = 0;
    }
    _imageV.image = Images[index];
    index++;
    
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

#pragma mark-搜索
-(void)search
{
    ListViewController *list = [[ListViewController alloc]init];
    list.isSeek = YES;
    list.searchName = self.s.tf.text;
    list.titleStr = @"搜查结果";
    [_s appearOrNot];
    _s.hidden = YES;
    [self.navigationController pushViewController:list animated:YES];
    
}
#pragma mark-屏幕出现
-(void)viewDidAppear:(BOOL)animated
{
    _s.hidden = NO;
    _s.backgroundColor = [self randomColor];
}


#pragma mark- 请求数据
-(void)loadData
{
//    [self.act startAnimating];
    //菊花
    [LBProgressHUD showHUDto:self.view animated:YES];
    
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

            [self.view addSubview:self.sphereView];//云
//            [self.act stopAnimating];
            //菊花
            [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [self performSelector:@selector(buttonPressed:) withObject:(UIButton*)[self.view viewWithTag:10010+2] afterDelay:0.7];
            
            //添加搜索框
            _s = [[SearchView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64) withSearchBlock:^{
                if (_s.tf.text.length == 0) {
                    WarnEnableEmptyLabel *warnLabel = [[WarnEnableEmptyLabel alloc]initWithFrame:CGRectMake(_s.tf.frame.origin.x-10, 64+10, 180, 35) withSuperView:self.navigationController.view withText:@"搜索内容不能为空哟"];
                    warnLabel.textColor = [UIColor cyanColor];
                }else{
                  [self search];
                }
               
            } withSuperView:self.navigationController.view];
            _s.backgroundColor = [self randomColor];
        });
            
        }
    } error:^(NSError *error) {
        //返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
        WarnLabel *warnLab = [WarnLabel creatWarnLabelWithY:myCenterY withSuperView:self.view];
        warnLab.text = @"网络请求失败";
//        [self.act stopAnimating];
             [LBProgressHUD hideAllHUDsForView:self.view animated:YES];//停止菊花
            
            //再次请求数据
            [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
            });
    }];
}

#pragma mark-懒加载
//-(UIActivityIndicatorView *)act
//{
//    if (!_act) {
//        _act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        [self.view addSubview:_act];
//        _act.center = CGPointMake(self.view.frame.size.width/2, myCenterY);
//        _act.color = [UIColor lightGrayColor];
//    }
//    return _act;
//}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark-花叶懒加载
-(DisperseBtn *)disView
{
    if (!_disView) {
        _disView = [[DisperseBtn alloc]init];
        _disView.frame = CGRectMake(100, 100, 65, 65);//60<*<80
        _disView.borderRect = CGRectMake(0, -HEIGHT, WIDTH, HEIGHT*3);
        _disView.closeImage = [UIImage imageNamed:@"花叶"];
    }
    return _disView;
}
#pragma mark-云标签懒加载
-(DBSphereView *)sphereView
{
    if (!_sphereView) {
        _sphereView = [[DBSphereView alloc] initWithFrame:CGRectMake(50, HEIGHT-100-49-51, 100, 100)];
        NSMutableArray *array = [NSMutableArray array];

        //添加按钮
        for (int i = 0;i<self.dataArray.count;i++) {
            Type *type = [self.dataArray objectAtIndex:i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(0, 0, 150, 20);
            btn.showsTouchWhenHighlighted = YES;
            [self setButtonTitleWithType:type forButton:btn];
            [btn setTitleColor:[self randomColor] forState:UIControlStateNormal];
            
            btn.titleLabel.font = [UIFont fontWithName:@"Zapfino" size:24];
            [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 10010+i;
            [array addObject:btn];
            [_sphereView addSubview:btn];
        }
        [_sphereView setCloudTags:array];
        _sphereView.backgroundColor = [UIColor clearColor];
    }
    return _sphereView;
}
#pragma maek-设置按钮title
-(void)setButtonTitleWithType:(Type *)type forButton:(UIButton *)button
{
    if (type.TypeId == 1) {
        [button setTitle:@"Season" forState:UIControlStateNormal];
    }else if (type.TypeId == 2){
        [button setTitle:@"Position" forState:UIControlStateNormal];
    }else if (type.TypeId == 3){
        [button setTitle:@"Type" forState:UIControlStateNormal];
    }else if (type.TypeId == 4){
        [button setTitle:@"Geomancy" forState:UIControlStateNormal];
    }else if (type.TypeId == 5){
        [button setTitle:@"Festival" forState:UIControlStateNormal];
    }
}
#pragma mark-设置中心按钮的中心位置
-(CGPoint)returnCenterPointForbutton:(UIButton *)btn
{
    CGFloat space = 50;
    if (btn.tag == 10010) {
        return  CGPointMake(space, 64+space);//左上方
    }else if (btn.tag == 10010+1){
        return CGPointMake(WIDTH/2, 64+space);//上中
    }else if (btn.tag == 10010+2){
        return CGPointMake(WIDTH/2, HEIGHT/2-50);//中间
    }else if (btn.tag == 10010+3){
        return CGPointMake(WIDTH-space, 64+space);//右上
    }else if (btn.tag == 10010+4){
        return CGPointMake(WIDTH-space, HEIGHT/2);//右中
    }
    return CGPointZero;
}
#pragma mark-点击云标签方法
- (void)buttonPressed:(UIButton *)btn
{
    _typeId = btn.tag-10010;
   Type *type = [self.dataArray objectAtIndex:btn.tag-10010];
    if (![self.view.subviews containsObject:self.disView]) {
        [self.view addSubview:self.disView];
    }
    if (btn.tag == 10010+2||btn.tag == 10010+4) {
        _disView.borderRect = CGRectMake(0, -HEIGHT, WIDTH, HEIGHT*3);
    }else{
        _disView.borderRect = CGRectMake(0, 64, WIDTH, HEIGHT-64-49);
    }
    [self setDisViewButtonsNum:type];
    
    //动画
    CGPoint point = btn.center;
    point.x += self.sphereView.frame.origin.x;
    point.y += self.sphereView.frame.origin.y;
    _disView.center = point;
    [UIView animateWithDuration:0.4 animations:^{
        _disView.center = [self returnCenterPointForbutton:btn];
    }completion:^(BOOL finished) {
        [_disView tap:nil];
    }];

}
#pragma mark-散开button的方法
- (void)setDisViewButtonsNum:(Type *)type{
    
    [_disView recoverBotton];
    
    for (UIView *btn in _disView.btns) {
        [btn removeFromSuperview];
    }
    NSMutableArray *titleArr = [NSMutableArray array];
    NSMutableArray *marr = [NSMutableArray array];
    for (int i = 0; i< type.contentArr.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        Content *content = type.contentArr[i];
        NSString *name = [NSString stringWithFormat:@"%@",content.TypeName];
        [btn setTitle:name forState:UIControlStateNormal];
        [btn setTitleColor:[self randomColor] forState:UIControlStateNormal];
        btn.showsTouchWhenHighlighted = YES;

        [btn.titleLabel sizeToFit];
        [marr addObject:btn];
        [titleArr addObject:content.TypeName];
        btn.tag = 100086+i;
        [btn addTarget:self action:@selector(buttonTagget:) forControlEvents:UIControlEventTouchUpInside];
    }
    _disView.btns = marr;//返回一个按钮数组
}

#pragma mark-点击散开按钮的方法
-(void)buttonTagget:(UIButton *)sender{
    ListViewController *list = [[ListViewController alloc]init];
    Type *type = self.dataArray[_typeId];
        list.type = type.TypeId;
        Content *content = type.contentArr[sender.tag-100086];
        list.typeId = content.TypeId;
        list.titleStr = content.TypeName;
        list.isSeek = NO;
        _s.hidden = YES;
        [self.navigationController pushViewController:list animated:YES];

}

#pragma mark-颜色
- (UIColor *)randomColor {
    CGFloat hue = (arc4random() % 256 / 256.0);  //  0.0 to 1.0
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
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
