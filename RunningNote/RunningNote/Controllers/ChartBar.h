//
//  ChartBar.h
//  RunningNote
//
//  Created by qingyun on 16/7/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChartBarDelegate <NSObject>

//要发送的消息
-(void)sendMessage:(id)message;

@end
@interface ChartBar : UIView

@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (nonatomic, weak) id<ChartBarDelegate> delegate;

@end
