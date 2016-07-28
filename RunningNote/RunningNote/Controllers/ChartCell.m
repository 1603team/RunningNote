//
//  ChartCell.m
//  Yueba
//
//  Created by qingyun on 16/7/22.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "ChartCell.h"
#import <AVOSCloudIM.h>
#import "FaceModel.h"

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

@implementation ChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIImage *image;
    
    if ([self.reuseIdentifier isEqualToString:@"chartcellleft"]) {
        //设置左边的bgimage
        image = [UIImage imageNamed:@"chart_left"];
    }else {
        image = [UIImage imageNamed:@"chart_right"];
    }
    
    //设置image拉伸
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(15, 35, 30, 35)];
    self.bgImage.image = image;
}

-(void)bandingMessage:(AVIMTypedMessage *)message{
    //根据message,绑定内容
    if ([message isKindOfClass:[AVIMTextMessage class]]) {
        //将文字内容转化为富文本,图文混排
        self.messageText.attributedText = [self faceAttributedStringWithMessage:message.text withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} FaceSize:28];
    }
    if ([message isKindOfClass:[AVIMAudioMessage class]]) {
        //设置录音的时间
        self.timelabel.text = [NSString stringWithFormat:@"%@s", message.text];
        //设置播放声音的动画
        if ([self.reuseIdentifier isEqualToString:@"chartcellleft"]) {
            self.voiceImage.animationImages = @[[UIImage imageNamed:@"ReceiverVoiceNodePlaying000"],
                                                [UIImage imageNamed:@"ReceiverVoiceNodePlaying001"],
                                                [UIImage imageNamed:@"ReceiverVoiceNodePlaying002"],
                                                [UIImage imageNamed:@"ReceiverVoiceNodePlaying003"]];
        }else{
            self.voiceImage.animationImages = @[[UIImage imageNamed:@"SenderVoiceNodePlaying000"],
                                                [UIImage imageNamed:@"SenderVoiceNodePlaying001"],
                                                [UIImage imageNamed:@"SenderVoiceNodePlaying002"],
                                                [UIImage imageNamed:@"SenderVoiceNodePlaying003"]];
        }
        
        self.messageText.hidden = YES;
        self.voiceBgView.hidden = NO;
        //调整音频视图的宽度
        NSInteger duration = message.text.integerValue;
        NSInteger maxLength = kScreenWidth - 152;
        NSInteger minLength = 100;
        NSInteger avage = maxLength / 20;//以三十秒为标准
        NSInteger length = duration * avage;
        //限制在最大值和最小值范围内
        length = maxLength < length ? maxLength : length;
        length = minLength > length ? minLength : length;
        _widthConstraint.constant = length;
        //动画的时间和播放次数
        _voiceImage.animationDuration = 1.f;
        _voiceImage.animationRepeatCount = duration;
    }
    
    //设置背景素材
    
}
//根据提供的文字和属性,将文字中的表情文字转化为图片
-(NSAttributedString *)faceAttributedStringWithMessage:(NSString *)message withAttributes:(NSDictionary *)attributes FaceSize:(CGFloat )facesize{
    
    //准备一个可变的属性字符串
    NSMutableAttributedString *messageAttributed = [[NSMutableAttributedString alloc] initWithString:message attributes:attributes];
    
    //读取表情文件,遍历数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Faces" ofType:@"plist"];
    NSDictionary *faceDict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *tt = faceDict[@"TT"];//tt表情数组
    [tt enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FaceModel *faceModel = [[FaceModel alloc] initWithDict:obj];
        //创建表情富文本(image)
        NSTextAttachment *attachment  = [[NSTextAttachment alloc] init];
        UIImage *image = [UIImage imageNamed:faceModel.imgName];
        attachment.image = image;
        attachment.bounds = CGRectMake(0, 0, facesize, facesize);
        //转化为属性字符
        NSAttributedString *faceString = [NSAttributedString attributedStringWithAttachment:attachment];
        
        //表情在文件中存在的位置
        NSRange resultRange;
        //没有查找的范围
        NSRange searchRange = NSMakeRange(0, messageAttributed.length);
        do {
            //将属性字符串中的表情字符串替换为对应的表情富文本
            //查到结果
            resultRange = [messageAttributed.string rangeOfString:faceModel.text options:0 range:searchRange];
            if (resultRange.length != 0) {
                //将查到结果的地方,替换为富文本
                [messageAttributed replaceCharactersInRange:resultRange withAttributedString:faceString];
                //新的搜索位置起点,考虑转化为图片后,字符长度的减少
                NSInteger index = NSMaxRange(resultRange) - (faceModel.text.length - 1);
                searchRange = NSMakeRange(index, messageAttributed.length - index);
            }else{
                //查找空间为零
                searchRange.length = 0;
            }
        } while (resultRange.length != 0 && searchRange.location < message.length);
    }];
    return messageAttributed;
}

- (void)startAnimation{
    [self.voiceImage startAnimating];
}
- (void)stopAnimation{
    [self.voiceImage stopAnimating];
}
//判断点击区域是否在声音视图区域内
-(BOOL)isTapedInContent:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:self.contentView];
    return CGRectContainsPoint(self.voiceBgView.frame, point);
}


@end
