//
//  Type.h
//  Flower&Melody
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 BF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Type : NSObject

@property(nonatomic,assign)NSInteger TypeId;
@property(nonatomic,strong)NSString *TypeName;
@property(nonatomic,strong)NSArray *Content;
//保存content的数组
@property(nonatomic,strong)NSMutableArray *contentArr;

-(void)setValueWith:(NSDictionary *)dic;

@end
