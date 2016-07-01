//
//  RRuningModel.h
//  RunningNote
//
//  Created by qingyun on 16/6/30.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RUserModel;
@interface RRuningModel : NSObject

@property (nonatomic, strong) RUserModel *user;     //用户信息
@property (nonatomic) NSInteger totalTime;          //累计时间
@property (nonatomic) NSInteger totalDistance;      //累计距离
@property (nonatomic) NSInteger totalCalorie;       //累计消耗
@property (nonatomic) NSInteger bestScore;          //最佳成绩
@property (nonatomic) NSInteger fastSpeed;          //最快速度
@property (nonatomic) NSInteger longestDistance;    //最长距离
@property (nonatomic) NSInteger longsetTime;        //最长时间
@property (nonatomic) NSInteger halfwayTime;        //马拉松半程时间
@property (nonatomic) NSInteger wholeTime;          //马拉松全程时间

//初始化方法
+ (instancetype)runWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
