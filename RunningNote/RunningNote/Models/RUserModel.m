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
#import "NSMutableDictionary+setObj.h"

@implementation RUserModel

+ (instancetype)sharedUserInfo {
    static RUserModel *userModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [QYDataBaseTool updateStatementsSql:createTabel withParsmeters:nil block:^(BOOL isOk, NSString *errorMsg) {
//            NSLog(@"%d",isOk);
        }];
        userModel = [[RUserModel alloc] init];
        [userModel getDataFromLocation];
    });
    return userModel;
}

- (void)getDataFromLocation {
    
    [self getDataFromNet];
    
    [QYDataBaseTool selectStatementsSql:SELECT_UserInfo_ALL withParsmeters:nil forMode:nil block:^(NSMutableArray *resposeOjbc, NSString *errorMsg) {
        if (resposeOjbc != nil) {
            NSDictionary *dict = resposeOjbc[0];
            _iconImage = dict[kIconImage];
            _nickName = dict[kNickName];
            _sex = [dict[kSex] integerValue];
            _height = [dict[kHeight] integerValue];
            _weight = [dict[kWeight] integerValue];
            _birthday = dict[kBirthday];
            _address = dict[kAddress];
        }
//        _totalDistance = [[user objectForKey:kTotalDistance] integerValue];
//        _totalTime = [[user objectForKey:kTotalTime] integerValue];
//        _totalCalorie = [[user objectForKey:ktotalCalorie] integerValue];
//        _bestScore = [[user objectForKey:kBestScore] integerValue];
//        _fastSpeed = [[user objectForKey:kFastSpeed] integerValue];
//        _longsetTime = [[user objectForKey:kLongestTime] integerValue];
//        _longestDistance = [[user objectForKey:kLongestDistance] integerValue];
//        _halfwayTime = [[user objectForKey:kHalfwayTime] integerValue];
//        _wholeTime = [[user objectForKey:kWholeTime] integerValue];
    }];
}

- (void)getDataFromNet {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    AVUser *user = [AVUser currentUser];
    [dict GHB_setObject:[user objectForKey:kIconImage] forKey:kIconImage];
    [dict GHB_setObject:[user objectForKey:kNickName] forKey:kNickName];
    [dict GHB_setObject:[user objectForKey:kSex] forKey:kSex];
    [dict GHB_setObject:[user objectForKey:kHeight] forKey:kHeight];
    [dict GHB_setObject:[user objectForKey:kWeight] forKey:kWeight];
    [dict GHB_setObject:[user objectForKey:kBirthday] forKey:kBirthday];
    [dict GHB_setObject:[user objectForKey:kAddress] forKey:kAddress];
    [QYDataBaseTool updateStatementsSql:Delete_UserInfo withParsmeters:nil block:^(BOOL isOk, NSString *errorMsg) {
    }];
    [QYDataBaseTool updateStatementsSql:INSERT_UserInfo_SQL withParsmeters:dict block:^(BOOL isOk, NSString *errorMsg) {
        NSLog(@"%d",isOk);
    }];
}

//- (NSDictionary *)getDataFromLeanCloud {
//    AVUser *user = [AVUser currentUser];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    if ([user objectForKey:kIconImage] == nil) {
//        [user setObject:[UIImage imageNamed:@"icon_35_s.png"] forKey:kIconImage];
//    }
////    (:iconImage,:nickName,:sex,:height,:weight,:birthday,:address)
//    [dict setObject:[user objectForKey:kIconImage] forKey:kIconImage];
//    [dict setObject:[user objectForKey:kNickName] forKey:kNickName];
//    [dict setObject:[user objectForKey:kSex] forKey:kSex];
//    [dict setObject:[user objectForKey:kHeight] forKey:kHeight];
//    [dict setObject:[user objectForKey:kWeight] forKey:kWeight];
//    [dict setObject:[user objectForKey:kBirthday] forKey:kBirthday];
//    [dict setObject:[user objectForKey:kAddress] forKey:kAddress];
//    return dict;
//    _iconImage = [user objectForKey:kIconImage];
//    _nickName = [user objectForKey:kNickName];
//    _sex = [user objectForKey:kSex];
//    _height = [[user objectForKey:kHeight] integerValue];
//    _weight = [[user objectForKey:kWeight] integerValue];
//    _birthday = [user objectForKey:kBirthday];
//    _address = [user objectForKey:kAddress];
//    _totalDistance = [[user objectForKey:kTotalDistance] integerValue];
//    _totalTime = [[user objectForKey:kTotalTime] integerValue];
//    _totalCalorie = [[user objectForKey:ktotalCalorie] integerValue];
//    _bestScore = [[user objectForKey:kBestScore] integerValue];
//    _fastSpeed = [[user objectForKey:kFastSpeed] integerValue];
//    _longsetTime = [[user objectForKey:kLongestTime] integerValue];
//    _longestDistance = [[user objectForKey:kLongestDistance] integerValue];
//    _halfwayTime = [[user objectForKey:kHalfwayTime] integerValue];
//    _wholeTime = [[user objectForKey:kWholeTime] integerValue];
//}

//+ (instancetype)userWithDictionary:(NSDictionary *)dict {
//    return [[self alloc] initWithDictionary:dict];
//}
//- (instancetype)initWithDictionary:(NSDictionary *)dict {
//    if (self = [super init]) {
////        _userName = dict[kUserName];
////        _passWord = dict[kPassWord];
//        _iconImage = dict[kIconImage];
//        _nickName = dict[kNickName];
//        _sex = dict[kSex];
//        _height = [dict[kHeight] integerValue];
//        _weight = [dict[kWeight] integerValue];
//        _birthday = dict[kBirthday];
//        _address = dict[kAddress];
//        _totalDistance = [dict[kTotalDistance] integerValue];
//        _totalTime = [dict[kTotalTime] integerValue];
//        _totalCalorie = [dict[ktotalCalorie] integerValue];
//        _bestScore = [dict[kBestScore] integerValue];
//        _fastSpeed = [dict[kFastSpeed] integerValue];
//        _longsetTime = [dict[kLongestTime] integerValue];
//        _longestDistance = [dict[kLongestDistance] integerValue];
//        _halfwayTime = [dict[kHalfwayTime] integerValue];
//        _wholeTime = [dict[kWholeTime] integerValue];
//    }
//    return self;
//}

@end
