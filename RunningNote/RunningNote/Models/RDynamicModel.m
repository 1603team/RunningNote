//
//  RDynamicModel.m
//  RunningNote
//
//  Created by qingyun on 16/7/13.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RDynamicModel.h"
#import <AVStatus.h>
@implementation RDynamicModel



+(instancetype)modelWithResults:(id)results{
    return [[self alloc] initWithResults:results];
}
-(instancetype)initWithResults:(id)results{
    if (self = [super init]) {
        AVStatus *status = results;
        _objectid = status.objectId;
        _messageId = status.messageId;
        _createdAt = status.createdAt;
        NSString *base = status.data[@"images"][@"base64"];
        if (base.length) {
            NSData *nsdataFromBase64String = [[NSData alloc] initWithBase64EncodedString:base options:NSDataBase64DecodingIgnoreUnknownCharacters];
            _images = nsdataFromBase64String;
        }
        _text   = status.data[@"text"];
        _location = status.data[@"location"];
        _userName = status.data[@"sourceName"];
        _iconData = status.data[@"iconImage"];
    }
    return self;
}


@end
