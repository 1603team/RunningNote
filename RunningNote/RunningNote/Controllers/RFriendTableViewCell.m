//
//  RFriendTableViewCell.m
//  RunningNote
//
//  Created by qingyun on 16/7/28.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RFriendTableViewCell.h"

@implementation RFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _iconImage.layer.cornerRadius = 30;
    [_iconImage.layer setBorderWidth:0.8]; //边框宽度
    [_iconImage.layer setBorderColor:[UIColor grayColor].CGColor];
    _iconImage.layer.masksToBounds = YES;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"friendcell_bg"]];
    self.backgroundView = imageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
