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

+(instancetype)sharemessageManager;


@end
