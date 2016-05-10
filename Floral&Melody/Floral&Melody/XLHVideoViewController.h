//
//  XLHVideoViewController.h
//  Floral&Melody
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHBaseViewController.h"

#import "XLHColumnViewController.h"

#import "XLHColumnTableViewCell.h"

#import "XLHSpecialModal.h"

#import "AFNetworking.h"

#import "UIImageView+WebCache.h"

#import "MJRefresh.h"

#import "XLHTOPTableViewCell.h"

@interface XLHVideoViewController : XLHBaseViewController<UITableViewDataSource,UITableViewDelegate>

/** tableView **/
@property (nonatomic, strong)UITableView * tableView;

/** dataArray **/
@property (nonatomic, strong)NSMutableArray * dataArray;

@end
