//
//  RMyTableViewCell.h
//  RunningNote
//
//  Created by qingyun on 16/7/5.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RDynamicModel;
@interface RMyTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *contentArray;//存放每个cell的内容
@property (nonatomic, strong) RDynamicModel *model;
@property (nonatomic, strong) UIViewController *tempTVC;

@end
