//
//  PlayerViewController.h
//  Radio
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 Carman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RadioListModel.h"
#import "UIImageView+WebCache.h"

@interface PlayerViewController : UIViewController

@property(nonatomic,strong)NSMutableArray *musicArray;
@property(nonatomic,assign)NSInteger currentIndex;

@end
