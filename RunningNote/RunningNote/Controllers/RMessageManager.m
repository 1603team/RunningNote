//
//  RMessageManager.m
//  RunningNote
//
//  Created by qingyun on 16/7/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RMessageManager.h"
#import "RUserModel.h"

@interface RMessageManager ()<AVIMClientDelegate>

@end

@implementation RMessageManager


+(instancetype)sharemessageManager{
    static RMessageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RMessageManager alloc] init];
    });
    return manager;
}

-(AVIMClient *)clint{
    if (_clint) {
        return _clint;
    }
    
    _clint = [[AVIMClient alloc] initWithClientId:[AVUser currentUser].username];
    _clint.delegate = self;
    return _clint;
}

#pragma mark - avclint receive message

//富文本类型消息接收
-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    //NSLog(@"type message:%@",message);
    [self.delegate conversation:conversation didReceiveTypedMessage:message];
}

@end
