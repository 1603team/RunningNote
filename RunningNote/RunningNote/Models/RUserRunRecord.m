//
//  RUserRunRecord.m
//  RunningNote
//
//  Created by qingyun on 16/7/28.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RUserRunRecord.h"
#import "AVOSCloud.h"
#import "DataBaseFile.h"
#import "QYDataBaseTool.h"
#import "NSMutableDictionary+setObj.h"

@implementation RUserRunRecord

+ (instancetype)recordModelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _title = dict[@"title"];
        _time = dict[@"time"];
        _distance = [dict[@"distance"] floatValue];
        _speed = [dict[@"speed"] floatValue];
        _isHome = [dict[@"isHome"] integerValue];
    }
    return self;
}

+ (instancetype)getbestData:(NSString *)data {
    [self getDataFromNet];
    __block RUserRunRecord *record;
    if ([data isEqualToString:@"time"]) {
        [QYDataBaseTool selectStatementsSql:[SELECT_MyRunNote_BY stringByAppendingString:@"time"] withParsmeters:nil forMode:@"RUserRunRecord" block:^(NSMutableArray *resposeOjbc, NSString *errorMsg) {
            if (resposeOjbc) {
                record = resposeOjbc.lastObject;
            }
        }];
    }
    if ([data isEqualToString:@"distance"]) {
        [QYDataBaseTool selectStatementsSql:[SELECT_MyRunNote_BY stringByAppendingString:@"distance"] withParsmeters:nil forMode:@"RUserRunRecord" block:^(NSMutableArray *resposeOjbc, NSString *errorMsg) {
            if (resposeOjbc) {
                record = resposeOjbc.lastObject;
            }
        }];
    }
    return record;
}

+ (void)getDataFromNet {
    AVQuery *query = [AVQuery queryWithClassName:@"runNote"];
//    [query whereKey:@"speed" equalTo:@"0.00"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSArray<AVObject *> *objs = objects;
        [QYDataBaseTool updateStatementsSql:Delete_MyRunNote withParsmeters:nil block:^(BOOL isOk, NSString *errorMsg) {
        }];
        for (AVObject *obj in objs) {
            NSMutableDictionary *mulDict = [NSMutableDictionary dictionary];
            [mulDict GHB_setObject:[obj objectForKey:@"title"] forKey:@"title"];
            [mulDict GHB_setObject:[obj objectForKey:@"time"] forKey:@"time"];
            [mulDict GHB_setObject:[obj objectForKey:@"distance"] forKey:@"distance"];
            [mulDict GHB_setObject:[obj objectForKey:@"speed"] forKey:@"speed"];
            [mulDict GHB_setObject:[obj objectForKey:@"isHome"] forKey:@"isHome"];
            
            [QYDataBaseTool updateStatementsSql:INSERT_MyRunNote_SQL withParsmeters:mulDict block:^(BOOL isOk, NSString *errorMsg) {
            }];
        }
    }];
}

@end
