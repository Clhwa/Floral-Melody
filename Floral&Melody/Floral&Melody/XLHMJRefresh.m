//
//  XLHMJRefresh.m
//  Floral&Melody
//
//  Created by lanou on 16/5/10.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHMJRefresh.h"

@implementation XLHMJRefresh

+ (XLHMJRefresh *)shareXLHMJRefresh
{
    static XLHMJRefresh * MJRefresh = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MJRefresh = [[XLHMJRefresh alloc] init];
    });
    return MJRefresh;
}

- (MJRefreshNormalHeader *)header
{
        MJRefreshNormalHeader * MJRefreshHeader = [[MJRefreshNormalHeader alloc] init];
        /* Text */
        [MJRefreshHeader setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
        [MJRefreshHeader setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
        [MJRefreshHeader setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
        
        /* Font */
        MJRefreshHeader.stateLabel.font = [UIFont systemFontOfSize:14];
        MJRefreshHeader.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:11];
        
        /* Color */
        MJRefreshHeader.stateLabel.textColor = [UIColor lightGrayColor];
        MJRefreshHeader.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];

    return MJRefreshHeader;
}

- (MJRefreshAutoNormalFooter *)footer
{

       MJRefreshAutoNormalFooter * footer = [[MJRefreshAutoNormalFooter alloc] init];
        
        /* Text */
        [footer setTitle:@"Click or drag up to refresh" forState:MJRefreshStateIdle];
        [footer setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"No more data" forState:MJRefreshStateNoMoreData];
        
        /* Font */
        footer.stateLabel.font = [UIFont systemFontOfSize:15];
        
        /* Color */
        footer.stateLabel.textColor = [UIColor lightGrayColor];

    return footer;
}
@end
