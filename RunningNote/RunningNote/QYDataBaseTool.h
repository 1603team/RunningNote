//
//  QYDataBaseTool.h
//  01-数据持久化作业
//
//  Created by qingyun on 16/6/20.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseFile.h"

typedef void(^callFiniseh)(BOOL isOk,NSString *errorMsg);
typedef void(^callResult)(NSMutableArray * resposeOjbc,NSString *errorMsg);

@interface QYDataBaseTool : NSObject

/**
 *  更新操作
 *
    @param sql sql语句  例如:insert into table values(:id,:name,:age);
 *  @param pars  参数 可以为nil
 *  @param block 执行成功,isOk yes,errorMsg错误信息
 */

+(void)updateStatementsSql:(NSString *)sql withParsmeters:(NSDictionary *)pars block:(callFiniseh)block;
/**
 *  查询操作
 *
 *  @param sql      SQL语句
 *  @param pars     参数,必须字典,可以传nil
 *  @param modeName mode的sting名称
 *  @param block    查询结果回调,数组,错误信息
 */
+(void)selectStatementsSql:(NSString *)sql withParsmeters:(NSDictionary *)pars forMode:(NSString *)modeName block:(callResult)block;


@end
