//
//  DataBaseUtil.h
//  UIJ02_数据库之FMDB
//
//  Created by lanou on 16/3/5.
//  Copyright © 2016年 BF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseUtil : NSObject

+(DataBaseUtil *)shareDataBase;

//创建表的方法:表名,列名数组
-(BOOL)createTableWithName:(NSString *)name withTextArray:(NSArray *)arr;
//添加数据的方法:表名,列名数组,数值数组
-(BOOL)insertWithTableName:(NSString *)name withObjectTextArray:(NSArray *)textArr withObjectValueArray:(NSArray *)valueArr;
//删除数据:表名,列名,数值
-(BOOL)deleteObjectWithTableName:(NSString *)name withTextName:(NSString *)text withValue:(NSString *)value;
//查询数据:表名,类名,类的属性数组
-(NSArray *)selectTable:(NSString *)name withClassName:(NSString *)className withtextArray:(NSArray *)textArr withList:(NSString *)list withYouWantSearchContent:(NSString *)content;

@end
