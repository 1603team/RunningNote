//
//  UIViewController+RVCForStoryBoard.h
//  RunningNote
//
//  Created by qingyun on 16/7/1.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RVCForStoryBoard)

+(__kindof UIViewController *)controllerForStoryBoardName:(NSString *)SBName ControllerName:(NSString *)VCName;

@end
