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
- (NSDictionary *)messagePara{
    if (!_messagePara) {
        _messagePara = [NSDictionary dictionary];
    }
    return _messagePara;
}

#pragma mark - avclint receive message

//富文本类型消息接收
-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    //NSLog(@"type message:%@",message);
    [self.delegate conversation:conversation didReceiveTypedMessage:message];
}
#pragma mark - 未读消息代理,获取未读消息
- (void)conversation:(AVIMConversation *)conversation didReceiveUnread:(NSInteger)unread {
    if (unread <= 0) return;
    __weak RMessageManager *weakSelf = self;
    // 否则从服务端取回未读消息
    [conversation queryMessagesFromServerWithLimit:unread callback:^(NSArray *objects, NSError *error) {
        if (!error && objects.count) {
            // 显示消息或进行其他处理
            AVIMTypedMessage *lastMessage = objects.lastObject;
            NSLog(@"数量%ld,信息%@,会话%@",unread,lastMessage.text,conversation.members);
        weakSelf.messagePara = @{@"unread":@(unread),@"message":lastMessage,@"conversation":conversation};
        }
    }];
}

@end
