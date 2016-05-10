//
//  XLHMJRefresh.h
//  Floral&Melody
//
//  Created by lanou on 16/5/10.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface XLHMJRefresh : NSObject
//MJRefreshAutoNormalFooter
@property (nonatomic, strong)MJRefreshNormalHeader * MJRefresh;

+ (XLHMJRefresh *)shareXLHMJRefresh;

- (MJRefreshNormalHeader *)header;

- (MJRefreshAutoNormalFooter *)footer;
@end
