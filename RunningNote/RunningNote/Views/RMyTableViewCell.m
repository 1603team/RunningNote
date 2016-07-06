//
//  RMyTableViewCell.m
//  RunningNote
//
//  Created by qingyun on 16/7/5.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RMyTableViewCell.h"
@interface RMyTableViewCell ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton    *iconBtn;//头像按钮
@property (weak, nonatomic) IBOutlet UILabel     *nicknameLabel;//用户昵称
@property (weak, nonatomic) IBOutlet UILabel     *timeLabel;//发表时间
@property (weak, nonatomic) IBOutlet UILabel     *locationLabel;//位置信息
@property (weak, nonatomic) IBOutlet UIView      *sharView;//分享的跑步记录
@property (weak, nonatomic) IBOutlet UILabel     *contentLabel;//发表的内容文字
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;//发表的内容图片
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;//评论列表

@end
@implementation RMyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commenteCell" forIndexPath:indexPath];
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
