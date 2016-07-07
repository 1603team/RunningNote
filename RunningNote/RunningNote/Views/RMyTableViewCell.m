//
//  RMyTableViewCell.m
//  RunningNote
//
//  Created by qingyun on 16/7/5.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RMyTableViewCell.h"
#import "RCommentesTableVC.h"
#import <Masonry.h>
@interface RMyTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton    *iconBtn;//头像按钮
@property (weak, nonatomic) IBOutlet UILabel     *nicknameLabel;//用户昵称
@property (weak, nonatomic) IBOutlet UILabel     *timeLabel;//发表时间
@property (weak, nonatomic) IBOutlet UILabel     *locationLabel;//位置信息
@property (weak, nonatomic) IBOutlet UIView      *sharView;//分享的跑步记录
@property (weak, nonatomic) IBOutlet UILabel     *contentLabel;//发表的内容文字
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;//发表的内容图片
@property (weak, nonatomic) IBOutlet UIView *commentesView;//放置评论列表
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentesViewHeight;//评论列表约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sharViewHeight;//分享记录高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contenImageViewHeight;//图片高度



@end
@implementation RMyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    

    // Initialization code
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    
    RCommentesTableVC *commentesTVC = [[RCommentesTableVC alloc] init];
    [_tempTVC addChildViewController:commentesTVC];
    
    commentesTVC.commentesArray = @[@"嘿嘿嘿",@"嚯嚯嚯",@"滴滴滴",@"闷闷闷",@"biubiubiu",@"DuangDuangDuang",@"锵锵锵",@"咚咚咚",@"这是评论",@"这个也是",@"恩，评论"];//temp
    _commentesViewHeight.constant = commentesTVC.commentesArray.count * 20;
    
    [_commentesView addSubview:commentesTVC.tableView];
    [commentesTVC.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(@0);
    }];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end





