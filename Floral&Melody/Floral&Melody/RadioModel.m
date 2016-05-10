//
//  RadioModel.m
//  Radio
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 Carman. All rights reserved.
//

#import "RadioModel.h"

@implementation RadioModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    if ([key isEqualToString:@"userinfo"]) {
        self.dic = value;
        [self.author setValuesForKeysWithDictionary:self.dic];
    }
}

@end
