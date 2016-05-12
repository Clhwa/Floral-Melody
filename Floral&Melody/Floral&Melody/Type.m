//
//  Type.m
//  Flower&Melody
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 BF. All rights reserved.
//

#import "Type.h"
#import "Content.h"
@implementation Type

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"key = %@",key);
}
-(void)setValueWith:(NSDictionary *)dic
{
    [self setValuesForKeysWithDictionary:dic];
    for (NSDictionary *dic1 in _Content) {
        Content *c = [[Content alloc]init];
        [c setValuesForKeysWithDictionary:dic1];
        [self.contentArr addObject:c];
    }
}
#pragma makr-懒加载
-(NSMutableArray *)contentArr
{
    if (!_contentArr) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}
@end
