//
//  LBPersonTool.h
//  SQLite
//
//  Created by libin on 16/2/29.
//  Copyright © 2016年 hdf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LBPerson;

@interface LBPersonTool : NSObject

/**
 保存一个联系人
*/
+ (void)save:(LBPerson *)person;

/**
 查询所有的联系人
 */
+ (NSArray *)query;

+ (NSArray *)queryWithCondition:(NSString *)condition;


@end
