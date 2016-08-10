//
//  RChatListCell.h
//  RunningNote
//
//  Created by qingyun on 16/8/9.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RChatListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic ) BOOL hasUnread;
@end
