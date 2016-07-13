//
//  RUserModel.h
//  RunningNote
//
//  Created by qingyun on 16/6/30.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RUserModel : NSObject

@property (nonatomic, strong) NSString *userName;    //用户名
@property (nonatomic, strong) NSString *passWord;    //密码
@property (nonatomic, strong) NSString *iconImage;   //头像
@property (nonatomic, strong) NSString *nickName;    //昵称
@property (nonatomic, strong) NSString *sex;         //性别
@property (nonatomic) NSInteger height;              //身高
@property (nonatomic) NSInteger weight;              //体重
@property (nonatomic, strong) NSString *birthday;    //生日
@property (nonatomic, strong) NSString *address;     //住址
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
+ (instancetype)userWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
//+ (instancetype)sharedUserInfo;

@end
