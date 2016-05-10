//
//  SearchView.h
//  Flower&Melody
//
//  Created by lanou on 16/5/7.
//  Copyright © 2016年 BF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^searchBlock)(void);

@interface SearchView : UIView

@property(nonatomic,strong)UITextField *tf;



-(instancetype)initWithFrame:(CGRect)frame withSearchBlock:(searchBlock)block withSuperView:(UIView *)superView;
-(void)appearOrNot;

@end
