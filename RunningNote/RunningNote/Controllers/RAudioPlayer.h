//
//  RAudioPlayer.h
//  RunningNote
//
//  Created by qingyun on 16/7/26.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RAudioPlayer : NSObject

+(instancetype)shareAudioPlayer;
//播放
-(void)playAudioWithData:(NSData *)data;
//停止
-(void)stopPlayer;
@end
