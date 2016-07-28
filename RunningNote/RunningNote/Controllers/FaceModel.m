//
//  FaceModel.m
//  Yueba
//
//  Created by qingyun on 16/7/23.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "FaceModel.h"

@implementation FaceModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        _text = dict[@"faceName"];
        _imgName = dict[@"imgName"];
    }
    return self;
}

@end
