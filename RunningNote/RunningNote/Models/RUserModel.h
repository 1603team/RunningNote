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
//初始化方法
+ (instancetype)userWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
