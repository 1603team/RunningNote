//
//  RDynamicModel.m
//  RunningNote
//
//  Created by qingyun on 16/7/13.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RDynamicModel.h"

@implementation RDynamicModel



+(instancetype)modelWithResults:(id)results{
    return [[self alloc] initWithResults:results];
}
-(instancetype)initWithResults:(id)results{
    if (self = [super init]) {
        _userName = results[@"localData"][@"userName"];
        _body     = results[@"localData"][@"body"];
        _objectid = results[@"objectId"];
        _createdAt = results[@"createdAt"];
        _images = results[@"images"];

    }
    
    
    return self;
}


@end
