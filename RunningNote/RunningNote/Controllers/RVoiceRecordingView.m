//
//  RVoiceRecordingView.m
//  RunningNote
//
//  Created by qingyun on 16/7/26.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RVoiceRecordingView.h"

@implementation RVoiceRecordingView


- (void)setPeakPower:(CGFloat)peakPower{
    for (int i = 0; i < 8; i++) {
        float j = (i + 1)/10.f;//音量的档次,每个档次差0.1
        if (peakPower <=j&& peakPower > j - 0.1) {
            NSString *imageName = [NSString stringWithFormat:@"RecordingSignal00%d", i +1];
            _voicedbImage.image = [UIImage imageNamed:imageName];
        }
        
    }
}

@end
