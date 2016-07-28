//
//  QYMessageBarButton.m
//  Yueba
//
//  Created by qingyun on 16/7/23.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "RMessageBarButton.h"

@implementation RMessageBarButton

-(void)awakeFromNib{
    //xib or storyboard 初始化方法
    self.showType = self.tag;
}

-(void)setShowType:(BarButtonType)showType{
    [self setTitle:nil forState:UIControlStateNormal];
    
    //根据类型,设置图片
    _showType = showType;
    switch (showType) {
        case kBarButtonAdd:
        {
            [self setImage:[UIImage imageNamed:@"messageBar_Add"] forState:UIControlStateNormal];
        }
            break;
        case kBarButtonFace:
        {
            [self setImage:[UIImage imageNamed:@"messageBar_Smiley"] forState:UIControlStateNormal];
        }
            break;
        case kBarButtonSend:
        {
            [self setTitle:@"发送" forState:UIControlStateNormal];
            [self setImage:nil forState:UIControlStateNormal];
        }
            break;
        case kBarButtonVoice:
        {
            [self setImage:[UIImage imageNamed:@"messageBar_Microphone"] forState:UIControlStateNormal];
        }
            break;
        case kBarButtonKeyboard:
        {
            [self setImage:[UIImage imageNamed:@"messageBar_Keyboard"] forState:UIControlStateNormal];
        }
        default:
            break;
    }
    
}


@end
