//
//  RMyTableViewCell.m
//  RunningNote
//
//  Created by qingyun on 16/7/5.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RMyTableViewCell.h"
#import "RCommentesTableVC.h"
#import "RDynamicModel.h"
#import <Masonry.h>
@interface RMyTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton    *iconBtn;//头像按钮
@property (weak, nonatomic) IBOutlet UILabel     *nicknameLabel;//用户昵称
@property (weak, nonatomic) IBOutlet UILabel     *timeLabel;//发表时间
@property (weak, nonatomic) IBOutlet UILabel     *locationLabel;//位置信息
//@property (weak, nonatomic) IBOutlet UIView      *sharView;//分享的跑步记录
@property (weak, nonatomic) IBOutlet UILabel     *contentLabel;//发表的内容文字
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;//发表的内容图片
@property (weak, nonatomic) IBOutlet UIView *commentesView;//放置评论列表
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentesViewHeight;//评论列表约束
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sharViewHeight;//分享记录高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contenImageViewHeight;//图片高度



@end
@implementation RMyTableViewCell


- (void)setModel:(RDynamicModel *)model{
    _model = model;
    _nicknameLabel.text = model.userName;
    NSString *baseStr = [model.iconData valueForKey:@"base64"];//base64转NSData
    if (baseStr.length) {
        NSData *nsdataFromBase64String = [[NSData alloc] initWithBase64EncodedString:baseStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *iconImage = [UIImage imageWithData:nsdataFromBase64String];
        [_iconBtn setImage:iconImage forState:UIControlStateNormal];
    }
    _iconBtn.layer.cornerRadius = 22.0;
    _iconBtn.clipsToBounds = YES;
    
    if (model.text) {                       //有无文字
        _contentLabel.text = model.text;
    }
    if (model.images) {                     //有无图片
        _contentImage.image = [UIImage imageWithData:model.images];
        _contenImageViewHeight.constant = 200;
    }else{
        _contenImageViewHeight.constant = 0;
    }
    if (model.location) {
        _locationLabel.text = model.location;
    }
    if (model.comments.count) {                   //有无评论
        _commentesViewHeight.constant = 200;
        RCommentesTableVC *commentesTVC = [[RCommentesTableVC alloc] init];
        [_tempTVC addChildViewController:commentesTVC];
        commentesTVC.commentesArray = model.comments;
        _commentesViewHeight.constant = commentesTVC.commentesArray.count * 20;
        [_commentesView addSubview:commentesTVC.tableView];
        [commentesTVC.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(@0);
        }];
    }else{
        _commentesViewHeight.constant = 0;
    }
    
    if (model.createdAt) {//创建时间
        NSString *str = [self dateStringFormDate:model.createdAt];
        _timeLabel.text = str;
    }
    
}

-(NSString *)dateStringFormDate:(NSDate *)date{
    NSTimeInterval interval = -[date timeIntervalSinceNow];
    if (interval < 60 * 30){//分级
        return [NSString stringWithFormat:@"%d分钟前",(int)(interval / 60)];
    }else if (interval < 60 * 60 * 24 ){//一天内
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        return [formatter stringFromDate:date];
    }else if (interval < 60 * 60 * 24 * 30 && interval >= 60 * 60 * 24 ){//天级
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        return [formatter stringFromDate:date];
    }else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        return [formatter stringFromDate:date];
    }
    return nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    

    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end





