//
//  RMyHeaderView.h
//  RunningNote
//
//  Created by qingyun on 16/7/6.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMyFootView : UITableViewHeaderFooterView

@property (nonatomic, copy) void (^changedSelectedBtn)(NSInteger tag);

@end
