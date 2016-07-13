//
//  RUserModel.m
//  RunningNote
//
//  Created by qingyun on 16/6/30.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RUserModel.h"
#import "RCommon.h"
#import "AVUser.h"
#import "QYDataBaseTool.h"

@implementation RUserModel

+ (instancetype)sharedUserInfo {
    static RUserModel *userModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
    return userModel;
}

- (void)getDataFromLeanCloud {
    AVUser *user = [AVUser currentUser];
    _iconImage = [user objectForKey:kIconImage];
    _nickName = [user objectForKey:kIconImage];
    _sex = [user objectForKey:kIconImage];
    _height = [[user objectForKey:kIconImage] integerValue];
    _weight = [[user objectForKey:kIconImage] integerValue];
    _birthday = [user objectForKey:kIconImage];
    _address = [user objectForKey:kIconImage];
    _totalDistance = [[user objectForKey:kIconImage] integerValue];
    _totalTime = [[user objectForKey:kIconImage] integerValue];
    _totalCalorie = [[user objectForKey:kIconImage] integerValue];
    _bestScore = [[user objectForKey:kIconImage] integerValue];
    _fastSpeed = [[user objectForKey:kIconImage] integerValue];
    _longsetTime = [[user objectForKey:kIconImage] integerValue];
    _longestDistance = [[user objectForKey:kIconImage] integerValue];
    _halfwayTime = [[user objectForKey:kIconImage] integerValue];
    _wholeTime = [[user objectForKey:kIconImage] integerValue];
}

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
        _totalDistance = [dict[kTotalDistance] integerValue];
        _totalTime = [dict[kTotalTime] integerValue];
        _totalCalorie = [dict[ktotalCalorie] integerValue];
        _bestScore = [dict[kBestScore] integerValue];
        _fastSpeed = [dict[kFastSpeed] integerValue];
        _longsetTime = [dict[kLongestTime] integerValue];
        _longestDistance = [dict[kLongestDistance] integerValue];
        _halfwayTime = [dict[kHalfwayTime] integerValue];
        _wholeTime = [dict[kWholeTime] integerValue];
    }
    return self;
}

@end
