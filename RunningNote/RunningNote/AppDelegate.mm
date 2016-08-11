//
//  AppDelegate.m
//  RunningNote
//
//  Created by qingyun on 16/6/29.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVUser.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface AppDelegate ()<BMKGeneralDelegate>
{
    CMMotionManager *motionmanager;
}
@property (nonatomic, strong)BMKMapManager *manager;

@end

@implementation AppDelegate

- (CMMotionManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        motionmanager = [[CMMotionManager alloc] init];
    });
    return motionmanager;
}

-(void)onGetNetworkState:(int)iError{
    NSLog(@"%d", iError);
}

-(void)onGetPermissionState:(int)iError{
    NSLog(@"%d", iError);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AVOSCloud setApplicationId:@"ffEtbcq1pwP43pIvnzUtKvg8-gzGzoHsz" clientKey:@"ADrWXda5eEhDEYTuhoCPfkEk"];
    //开启未读消息
    [AVIMClient setUserOptions:@{
        AVIMUserOptionUseUnread: @(YES)
    }];
    
    UIViewController *rootVC;
    if ([AVUser currentUser] != nil) {
        //显示首页
        AVUser *user = [AVUser currentUser];
        if ([user objectForKey:@"nickName"] == nil) {
            rootVC = [self getVCFromStoryBoardWithIdentifier:@"RUserInfoNav"];
        }else{
            rootVC = [self getVCFromStoryBoardWithIdentifier:@"MainTabBarController"];
        }
    }else {
        //注册登录
        rootVC = [self getVCFromStoryBoardWithIdentifier:@"RLloginVC"];
    }
    self.window.rootViewController = rootVC;
    
    _manager = [[BMKMapManager alloc] init];
    [_manager start:@"aiLaK0w1oZRwEd86IcCGWaFmbwljmGSD" generalDelegate:self];
    
    return YES;
}

//根据id从storyBoard中获取控制器
-(UIViewController *)getVCFromStoryBoardWithIdentifier:(NSString *)identifier{
    UIStoryboard *sb;
    if ([identifier isEqualToString:@"RUserInfoNav"]) {
        sb = [UIStoryboard storyboardWithName:@"RHBStoryboard" bundle:nil];
    }
    if ([identifier isEqualToString:@"MainTabBarController"]) {
//        _clientDelegate = [[AVIMClient alloc] initWithClientId:[AVUser currentUser].username];
        sb = [UIStoryboard storyboardWithName:@"RJianYe" bundle:nil];
    }
    if ([identifier isEqualToString:@"RLloginVC"]) {
       sb = [UIStoryboard storyboardWithName:@"RHBStoryboard" bundle:nil];
    }
    return [sb instantiateViewControllerWithIdentifier:identifier];
}


-(void)showHomeVC{
    UIViewController *rootVC;
    AVUser *user = [AVUser currentUser];
    if ([user objectForKey:@"nickName"] == nil) {
        rootVC = [self getVCFromStoryBoardWithIdentifier:@"RUserInfoNav"];
    }else{
        rootVC = [self getVCFromStoryBoardWithIdentifier:@"MainTabBarController"];
    }

    _window.rootViewController = rootVC;
}

- (void)showLoginVC {
    _window.rootViewController = [self getVCFromStoryBoardWithIdentifier:@"RLloginVC"];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
