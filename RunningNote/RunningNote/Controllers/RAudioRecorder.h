//
//  RAudioRecorder.h
//  RunningNote
//
//  Created by qingyun on 16/7/26.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//更新分贝的block
typedef void (^UpdatePowerValue) (CGFloat power);


@interface RAudioRecorder : NSObject
@property (nonatomic)NSTimeInterval currentTimeInterval;//录音时长

@property (nonatomic, copy)   UpdatePowerValue updatePower;



- (void)prepareRecordWith:(NSString *)path;
//暂停
- (void)pauseRecord;
//继续录音
- (void)continueRecord;
//结束录音
- (void)stopRecord;
- (void)updatePowerValue:(NSTimer *)timer;

- (void)cancel;//取消
@end
