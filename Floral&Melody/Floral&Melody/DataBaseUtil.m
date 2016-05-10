//
//  DataBaseUtil.m
//  UIJ02_数据库之FMDB
//
//  Created by lanou on 16/3/5.
//  Copyright © 2016年 BF. All rights reserved.
//

#import "DataBaseUtil.h"

#import "FMDatabase.h"

//静态
static DataBaseUtil *dataBase = nil;

//利用延展添加私有属性
@interface DataBaseUtil ()//延展
@property(nonatomic,strong)FMDatabase *db;
@end

@implementation DataBaseUtil
//产生单例对象的方法
+(DataBaseUtil *)shareDataBase
{
    if (dataBase == nil) {
        dataBase = [[DataBaseUtil alloc]init];
    }
    return dataBase;
}

//初始化方法中完成文件与对象的连接
-(id)init
{
    self = [super init];
    if (self) {
      NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString *dbPath = [docPath stringByAppendingPathComponent:@"FM.sqlite"];//建立文件
        self.db = [FMDatabase databaseWithPath:dbPath];
    }
    return self;
}
#pragma makr-建表
-(BOOL)createTableWithName:(NSString *)name withTextArray:(NSArray *)arr
{
    //开启
    if ([_db open]) {
        NSString *text = [NSString string];
        for (NSString *str in arr) {
            text = [text stringByAppendingFormat:@",%@ text",str];
        }
        //创建sql语句 ...建立文件里的表格
        NSString *sql =[NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement%@)",name,text];
        
        //执行语句
        BOOL result = [_db executeUpdate:sql];
        [_db close];//关闭
        return result;
    }
    return NO;
}

-(BOOL)insertWithTableName:(NSString *)name withObjectTextArray:(NSArray *)textArr withObjectValueArray:(NSArray *)valueArr
{
    if ([_db open]) {
        //text
        NSString *text = [textArr componentsJoinedByString:@","];
        NSString *value = [NSString string];
        for ( int i = 0; i<valueArr.count; i++) {
            if (i == valueArr.count-1) {
                value = [value stringByAppendingFormat:@"'%@'",valueArr[i]];
            }else{
            value = [value stringByAppendingFormat:@"'%@',",valueArr[i]];
            }
        }
        //创建语句
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@) values (%@)",name,text,value];
        //执行语句
        BOOL result = [_db executeUpdate:sql];
        [_db close];
        return result;
    }
    return NO;
}


-(BOOL)deleteObjectWithTableName:(NSString *)name withTextName:(NSString *)text withValue:(NSString *)value
{
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",name,text,value];        BOOL result = [_db executeUpdate:sql];
        [_db close];
        return  result;
    }
    return NO;
}

-(NSArray *)selectTable:(NSString *)name withClassName:(NSString *)className withtextArray:(NSArray *)textArr
{
    NSMutableArray *array = [NSMutableArray array];
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from %@",name];
        
       FMResultSet *set = [_db executeQuery:sql];
        while ([set next]) {
          NSObject *object = [NSClassFromString(className) alloc];
            for (NSString *text in textArr) {
                NSString *value = [set stringForColumn:text];
                [object setValue:value forKey:text];
            }
            [array addObject:object];
        }
        [_db close];
    }
    return array;
}

@end
