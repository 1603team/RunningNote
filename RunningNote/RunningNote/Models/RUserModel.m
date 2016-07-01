//
//  RUserModel.m
//  RunningNote
//
//  Created by qingyun on 16/6/30.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RUserModel.h"
#import "RCommen.h"

@implementation RUserModel

+ (instancetype)userWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _userName = dict[kUserName];
        _passWord = dict[kPassWord];
        _iconImage = dict[kIconImage];
        _nickName = dict[kNickName];
        _sex = dict[kSex];
        _height = [dict[kHeight] integerValue];
        _weight = [dict[kWeight] integerValue];
        _birthday = dict[kBirthday];
        _address = dict[kAddress];
    }
    return self;
}

@end
