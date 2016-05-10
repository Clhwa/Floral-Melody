//
//  XLHSpecialViewController.h
//  Floral&Melody
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BFMenuView.h"

#import "XLHSpecialMenuView.h"

#import "XLHMenuViewController.h"

#import "XLHArticleViewController.h"

#import "XLHVideoViewController.h"

#import "XLHColumnViewController.h"

#import "XLHColumnTableViewCell.h"

#import "XLHSpecialModal.h"

#import "XLHTOPViewController.h"

#import "XLHTipsView.h"

#import "UIView+Explode.h"

#import "objc/runtime.h"

#import "XLHMJRefresh.h"
@interface XLHSpecialViewController : XLHBaseViewController <UITableViewDataSource,UITableViewDelegate>

/** Menu View **/
@property (nonatomic, strong)XLHMenuViewController * XLHMenuVC;

/** spaceView **/
@property (nonatomic , strong)UIView * spaceView;

/** SpecialMenuView **/
@property (nonatomic, strong)BFMenuView * BFMenuView;

/** UITableView **/
@property (nonatomic, strong)UITableView * tableView;

/** dataArray **/
@property (nonatomic, strong)NSMutableArray * dataArray;

/** TipsView **/
@property (nonatomic, retain)XLHTipsView * tipsView;

@end
