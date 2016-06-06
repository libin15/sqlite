//
//  LBPersonTool.m
//  SQLite
//
//  Created by libin on 16/2/29.
//  Copyright © 2016年 hdf. All rights reserved.
//

#import "LBPersonTool.h"
#import "LBPerson.h"
#import <sqlite3.h>

static sqlite3 *_db;

@implementation LBPersonTool

+ (void)initialize {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"person.sqlite"];
    
    
    
    const char *cfileName = fileName.UTF8String;
    int result = sqlite3_open(cfileName, &_db); //打开数据库 如果文件不存在那就自动创建一个
    if (result == SQLITE_OK) {
        NSLog(@"打开成功");
        //创建表格
        const char *sql = "CREATE TABLE IF NOT EXISTS t_person (id integer PRIMARY KEY AUTOINCREMENT,name text NOT NULL,age integer NOT NULL);";
        char *errmsg = NULL;
        result = sqlite3_exec(_db, sql, NULL, NULL, &errmsg);
        if (result == SQLITE_OK) {
            NSLog(@"创建表格成功");
        } else {
            printf("创建表格失败 --- %s",errmsg);
        }
    } else {
        NSLog(@"打开表失败");
    }
}


+ (void)save:(LBPerson *)person {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_person (name,age) VALUES ('%@',%ld);",person.name,(long)person.age];
    const char *insertSql = sql.UTF8String;
    char *errmsg = NULL;
    sqlite3_stmt *stmt = NULL;
    sqlite3_exec(_db, insertSql, NULL, NULL, &errmsg);
   // sqlite3_prepare(_db, insertSql, -1, &stmt, NULL);
    if (errmsg) {
        NSLog(@"插入失败");
    } else {
        NSLog(@"插入成功");
    }
}


+ (NSArray *)query {
     return [self queryWithCondition:@""];
}


+ (NSArray *)queryWithCondition:(NSString *)condition {
    NSMutableArray *persons = nil;
    NSString *nsSql=[NSString stringWithFormat:@"SELECT id,name,age FROM t_person WHERE name like '%%%@%%' ORDER BY age ASC;",condition];
    NSLog(@"sql == %@", nsSql);
    const char *sql = nsSql.UTF8String;
    sqlite3_stmt *stmt = NULL; //这个相当于ODBC的Command对象，用于保存编译好的SQL语句
    
    if (sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL) == SQLITE_OK) {
        NSLog(@"查询语句没有问题");
        persons = [NSMutableArray array];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int ID = sqlite3_column_int(stmt, 0);
            const unsigned char *name = sqlite3_column_text(stmt, 1);
            int age =  sqlite3_column_int(stmt, 2);
            
            LBPerson *person = [[LBPerson alloc]init];
            person.ID = ID;
            person.age = age;
            person.name = [NSString stringWithUTF8String:(const char *)name];
            [persons addObject:person];
        }
    } else {
        NSLog(@"失败了");
    }

      return persons;
}
@end
