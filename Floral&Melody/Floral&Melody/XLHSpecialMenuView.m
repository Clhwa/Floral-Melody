//
//  XLHSpecialMenuView.m
//  Floral&Melody
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHSpecialMenuView.h"

@interface XLHSpecialMenuView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    
    NSArray * dataArray;
}

@end

@implementation XLHSpecialMenuView

/*
 *  author @西兰花
 *
 *  2016 - 05 - 04
 *
 *  All rights reserved.
 */

+ (instancetype)XLHSpecialMenuViewWithFrame:(CGRect)frame titleItems:(NSArray *)titleItems
{
    XLHSpecialMenuView * xlh = [[XLHSpecialMenuView alloc] initWithFrame:frame titleItems:titleItems];
    
    return xlh;
}



/**  self init **/
- (instancetype) initWithFrame:(CGRect)frame titleItems:(NSArray *)titleItems
{
    if (self = [super init]) {
        
        dataArray = [NSArray array];
        dataArray = titleItems;
        
        self.frame = frame;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.userInteractionEnabled = YES;
        
        [self createTableView];
        
    }
    return self;
}

- (void)createTableView
{
    /*
     * tableView --- setting
     */
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    
    _tableView.backgroundColor = [UIColor redColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius = 10;
    
    _tableView.bounces = NO;
    [self addSubview:_tableView];
}


/*
 * cell --- num
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

/*
 * cell --- setting
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    XLHMenuTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XLHMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.titleLabel.text = [dataArray objectAtIndex:indexPath.row];

    return cell;
}


/*
 * cell --- height
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 37.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToArticle" object:nil];
        
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToVideo" object:nil];
    }
}


@end
