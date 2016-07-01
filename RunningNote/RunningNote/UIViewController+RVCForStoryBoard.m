//
//  UIViewController+RVCForStoryBoard.m
//  RunningNote
//
//  Created by qingyun on 16/7/1.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "UIViewController+RVCForStoryBoard.h"

@implementation UIViewController (RVCForStoryBoard)

+(UIViewController *)controllerForStoryBoardName:(NSString *)SBName ControllerName:(NSString *)VCName{
    return [[UIStoryboard storyboardWithName:SBName bundle:nil] instantiateViewControllerWithIdentifier:VCName];
}


@end
