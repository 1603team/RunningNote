//
//  RAudioPlayer.m
//  RunningNote
//
//  Created by qingyun on 16/7/26.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface RAudioPlayer ()<AVAudioPlayerDelegate>

@property (nonatomic, strong)AVAudioPlayer *audioPlayer;
@end


@implementation RAudioPlayer
+(instancetype)shareAudioPlayer{
    static RAudioPlayer *player;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[RAudioPlayer alloc] init];
    });
    return player;
}

-(void)playAudioWithData:(NSData *)data{//开始
    //设置使用扬声器
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
    if (error) {
        NSLog(@"播放错误%@",error);
    }
    _audioPlayer.delegate = self;
    [_audioPlayer play];
    [self configProximityMonitorEnableState:YES];
}
-(void)stopPlayer{//停止
    [_audioPlayer stop];
    //唤醒其他使用扬声器的应用播放
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    [self configProximityMonitorEnableState:NO];
}
//开启或关闭距离传感器
-(void)configProximityMonitorEnableState:(BOOL)enabled{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:enabled];
    if (enabled) {
        //添加距离感应器状态改变的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStatueChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
    
}
//选择使用听筒播放还是扬声器播放声音
- (void)proximityStatueChange:(NSNotificationCenter *)center{
    if ([UIDevice currentDevice].proximityState) {
        //距离感应器接受到感应
        //设置听筒播放
        NSError *error;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
        
    }else{
        //话筒播放
        NSError *error;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    }
}
#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self configProximityMonitorEnableState:NO];
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    [self configProximityMonitorEnableState:NO];
}




@end




