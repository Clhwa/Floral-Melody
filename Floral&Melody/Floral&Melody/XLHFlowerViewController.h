//
//  XLHFlowerViewController.h
//  Floral&Melody
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHBaseViewController.h"

#import "AFNetworking.h"

#import "XLHColumnTableViewCell.h"

#import "XLHSpecialModal.h"

#import "XLHColumnViewController.h"
@interface XLHFlowerViewController : XLHBaseViewController<UITableViewDataSource,UITableViewDelegate>

/** tableView **/
@property (nonatomic, strong)UITableView * tableView;


/** dataArray **/
@property (nonatomic, strong)NSMutableArray * dataArray;

/** API **/
@property (nonatomic, strong)NSString * API;
@property(nonatomic,strong)NSString *titleStr;
@end
