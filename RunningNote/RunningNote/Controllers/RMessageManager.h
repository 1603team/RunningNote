//
//  RMessageManager.h
//  RunningNote
//
//  Created by qingyun on 16/7/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud.h>
#import <AVOSCloudIM.h>

@protocol MessageManagerDelegate <NSObject>

//收到消息,通知Delegate
-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message;

@end

@interface RMessageManager : NSObject

@property (nonatomic, strong)AVIMClient *clint;
@property (nonatomic, weak)id<MessageManagerDelegate> delegate;
@property (nonatomic, strong)NSDictionary *messagePara;//会话的未读信息条数，会话对象，会话最后一条消息对象
+(instancetype)sharemessageManager;


@end
