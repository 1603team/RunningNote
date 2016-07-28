//
//  RVoiceRecordingView.h
//  RunningNote
//
//  Created by qingyun on 16/7/26.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RVoiceRecordingView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *voicedbImage;//分贝的图标
@property (nonatomic) CGFloat peakPower;//说话的音量
@end
