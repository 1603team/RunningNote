//
//  ChartCell.h
//  Yueba
//
//  Created by qingyun on 16/7/22.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVUser;

@class AVIMTypedMessage;
@interface ChartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UILabel *messageText;//文字信息


@property (weak, nonatomic) IBOutlet UIView *voiceBgView;//语音背景
@property (weak, nonatomic) IBOutlet UIImageView *voiceImage;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;//语音时常
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;//语音条宽度


@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (nonatomic, strong) AVUser *friendUser;




-(void)bandingMessage:(AVIMTypedMessage *)message;

- (void)startAnimation;//开始动画
- (void)stopAnimation;//结束动画

-(BOOL)isTapedInContent:(UITapGestureRecognizer *)tap;

@end
