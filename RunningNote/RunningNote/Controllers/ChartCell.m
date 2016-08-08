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
#import <AVOSCloud.h>
#import "RUserModel.h"
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

@implementation ChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFriendUser:(AVUser *)friendUser{
    _friendUser = friendUser;
    UIImage *image;
    if ([self.reuseIdentifier isEqualToString:@"chartcellleft"] || [self.reuseIdentifier isEqualToString:@"chartimagecellleft"] || [self.reuseIdentifier isEqualToString:@"charcellvoiceleft"]) {
        //设置左边的bgimage
        image = [UIImage imageNamed:@"chart_left"];
        NSDictionary *localData = [_friendUser valueForKey:@"localData"];
        NSData *icomImageData = [localData valueForKey:@"iconImage"];
        _icon.image = [UIImage imageWithData:icomImageData];
    }else {
        image = [UIImage imageNamed:@"chart_right"];
        NSData *iconData = [RUserModel sharedUserInfo].iconImage;
        UIImage *myIcon = [UIImage imageWithData:iconData];
        _icon.image = myIcon;
    }
    [_icon.layer setCornerRadius:22.0];
    [_icon.layer setBorderWidth:0.8]; //边框宽度
    [_icon.layer setBorderColor:[UIColor grayColor].CGColor];
    _icon.layer.masksToBounds = YES;
    //设置image拉伸
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(15, 35, 30, 35)];
    self.bgImage.image = image;
    _bgImage.layer.shadowColor = [UIColor blackColor].CGColor;
    _bgImage.layer.shadowOffset = CGSizeMake(0.1, 1);
    _bgImage.layer.shadowOpacity = 0.8;
}

-(void)bandingMessage:(AVIMTypedMessage *)message{
    if (message.sendTimestamp) {
        [self dateFromTimestamp:[NSString stringWithFormat:@"%lld",message.sendTimestamp]];
    }else{
        NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        _timeLabel.text =  [formatter stringFromDate:now];
    }
    if ([message isKindOfClass:[AVIMTextMessage class]]) {//1.文本信息
        self.messageText.attributedText = [self faceAttributedStringWithMessage:message.text withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} FaceSize:30];
    }
    if ([message isKindOfClass:[AVIMAudioMessage class]]) {//2.语音信息
        [self bandingAudioMessage:(AVIMAudioMessage *)message];
    }
    
    if ([message isKindOfClass:[AVIMImageMessage class]]) {//3.图片消息
        [self bandingImageMessage:(AVIMImageMessage *)message];
        
    }
    //设置背景素材
}
- (void)dateFromTimestamp:(NSString *)timeStamp{//时间戳转时间

    NSTimeInterval time=([timeStamp doubleValue] / 1000);
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    NSTimeInterval interval = -[detaildate timeIntervalSinceNow];
    if (interval < 60 * 60 * 24 ){//一天内
        [formatter setDateFormat:@"HH:mm"];
       _timeLabel.text =  [formatter stringFromDate:detaildate];
    }else{
        [formatter setDateFormat:@"MM-dd"];
       _timeLabel.text =  [formatter stringFromDate:detaildate];
    }
    
}
//图像消息
- (void)bandingImageMessage:(AVIMImageMessage *)message{
    [message.file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        self.showImage.image = image;
    }];
    NSString *text = message.text;
    NSArray *imageSize = [text componentsSeparatedByString:@":"];
    CGFloat width = [imageSize[0] floatValue];
    CGFloat height = [imageSize[1] floatValue];
    //以250为界限
    if (width > 250 || height >250) {
        if (width > height) {
            height = 250 / width *height;
            width = 250;
        }else{
            width = 250 / height *width;
            height = 250;
        }
    }
    //更新image宽高约束
    self.imageWith.constant = width;
    self.imageHeight.constant = height;
    
    self.showImage.layer.cornerRadius = 5;
    self.showImage.layer.masksToBounds = YES;
    
    
}
//音频消息
- (void)bandingAudioMessage:(AVIMAudioMessage *)message{
//    _voiceImage.hidden = NO;
    //设置录音的时间
    self.timelabel.text = [NSString stringWithFormat:@"%@s", message.text];
    //设置播放声音的动画
    if ([self.reuseIdentifier isEqualToString:@"charcellvoiceleft"]) {
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
    
//    self.messageText.hidden = YES;
//    self.voiceBgView.hidden = NO;
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
