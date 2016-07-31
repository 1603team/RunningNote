//
//  ChartCell.h
//  Yueba
//
//  Created by qingyun on 16/7/22.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVIMTypedMessage;
@interface ChartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UILabel *messageText;

@property (weak, nonatomic) IBOutlet UIView *voiceBgView;
@property (weak, nonatomic) IBOutlet UIImageView *voiceImage;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;






-(void)bandingMessage:(AVIMTypedMessage *)message;

- (void)startAnimation;//开始动画
- (void)stopAnimation;//结束动画

-(BOOL)isTapedInContent:(UITapGestureRecognizer *)tap;

@end
