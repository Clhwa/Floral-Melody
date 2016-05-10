//
//  ListViewController.h
//  Flower&Melody
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 BF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController
@property(nonatomic,assign)BOOL isSeek;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,assign)NSInteger typeId;
@property(nonatomic,strong)NSString *searchName;

@end
