//
//  RAudioRecorder.m
//  RunningNote
//
//  Created by qingyun on 16/7/26.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>


@interface RAudioRecorder  ()

@property (nonatomic, strong) AVAudioRecorder *recorder; //录音
@property (nonatomic, strong) NSString        *filePath; //保存路径
@property (nonatomic, strong) NSTimer         *timer;//更新分贝


@end

@implementation RAudioRecorder

- (void)prepareRecordWith:(NSString *)path{
    NSError *error;
    //配置录音环境
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error){
        NSLog(@"%@",error);
    }
    //准备录音的参数
    NSDictionary *settings = @{AVFormatIDKey : @(kAudioFormatMPEG4AAC),
                               AVSampleRateKey : @16000,
                               AVNumberOfChannelsKey : @1};
    //初始化录音
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:path] settings:settings error:&error];
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];//可以获取分贝
    
    //初始化timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updatePowerValue:) userInfo:nil repeats:YES];
    
    //开始录音
    [self.recorder record];
    
    
    
    
}
//暂停
- (void)pauseRecord{
    if (self.recorder.recording) {
        [self.recorder pause];
        //暂停timer,设置触发时间为以后
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}
//继续录音
- (void)continueRecord{
    if (!self.recorder.recording) {
        [self.recorder record];
        //继续timer,设置触发时间为过去
        [self.timer setFireDate:[NSDate distantPast]];
    }
}
//结束录音
- (void)stopRecord{
    //计算时间
    NSTimeInterval time = self.recorder.currentTime;
    //防止录音时间过短,设置最短时间为一秒
    self.currentTimeInterval = time < 1 ? 1 : time;
    [self.recorder stop];
    
    //让timer失效
    [self.timer invalidate];
    self.timer = nil;
    
    //恢复其他被打断的录音
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
}

- (void)updatePowerValue:(NSTimer *)timer{//计算
    [self.recorder updateMeters];//更新分贝
    self.currentTimeInterval = self.recorder.currentTime;
    CGFloat peakPower = [_recorder averagePowerForChannel:0];
    double alpha = 0.015;
    double peakPowerForChannel = pow(10, (alpha * peakPower));//计算出分贝值
    self.updatePower(peakPowerForChannel);
                                     
}
- (void)cancel{//取消
    [self.recorder stop];
    
    //让timer失效
    [self.timer invalidate];
    self.timer = nil;
    
    //恢复其它被打断的录音
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    
    //删除文件
    [[NSFileManager defaultManager] removeItemAtPath:self.filePath error:nil];
}

//发送

@end













