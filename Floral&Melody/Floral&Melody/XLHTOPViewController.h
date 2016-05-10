//
//  XLHTOPViewController.h
//  Floral&Melody
//
//  Created by lanou on 16/5/6.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHBaseViewController.h"

#import "XLHTOPModal.h"

#import "AFNetworking.h"

#import "UIImageView+WebCache.h"

#import "XLHTOPTableViewCell.h"

#import "XLHColumnViewController.h"
@interface XLHTOPViewController : XLHBaseViewController<UITableViewDataSource,UITableViewDelegate>

/** tableView **/
@property (nonatomic, strong)UITableView * tableView;

/** dataArray **/
@property (nonatomic, strong)NSMutableArray * dataArray;


@end
