//
//  ChartVC.h
//  RunningNote
//
//  Created by qingyun on 16/7/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVStatus.h>
#import <AVIMConversation.h>

@interface ChartVC : UIViewController
@property (nonatomic, strong)AVUser *friendUser;
@property (nonatomic, strong)AVIMConversation *conversation;

@end
