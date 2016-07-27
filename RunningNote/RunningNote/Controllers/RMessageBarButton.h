//
//  QYMessageBarButton.h
//  Yueba
//
//  Created by qingyun on 16/7/23.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kBarButtonAdd = 1,
    kBarButtonFace,
    kBarButtonVoice,
    kBarButtonSend,
    kBarButtonKeyboard
} BarButtonType;

@interface RMessageBarButton : UIButton

@property (nonatomic)BarButtonType showType;

@end
