//
//  AppDelegate.h
//  RunningNote
//
//  Created by qingyun on 16/6/29.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloudIM.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AVIMClient *clientDelegate;

- (void)showHomeVC;
- (void)showLoginVC;

@end

