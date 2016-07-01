//
//  RRuningModel.m
//  RunningNote
//
//  Created by qingyun on 16/6/30.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RRuningModel.h"
#import "RUserModel.h"
#import "RCommon.h"

@implementation RRuningModel

+ (instancetype)runWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _user = [RUserModel userWithDictionary:dict[kUser]];
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
