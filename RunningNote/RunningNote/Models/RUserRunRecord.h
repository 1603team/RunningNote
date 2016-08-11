//
//  RUserRunRecord.h
//  RunningNote
//
//  Created by qingyun on 16/7/28.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RUserRunRecord : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *time;
@property (nonatomic) float distance;
@property (nonatomic) float speed;
@property (nonatomic, strong) NSString *pace;
@property (nonatomic, strong) NSString *calorie;
@property (nonatomic) BOOL isHome;

+ (instancetype)recordModelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (instancetype)getbestData:(NSString *)data;

@end
