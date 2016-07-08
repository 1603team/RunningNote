//
//  RMyHeaderView.m
//  RunningNote
//
//  Created by qingyun on 16/7/6.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RMyFootView.h"
#import <Masonry.h>

#define RScreenW [UIScreen mainScreen].bounds.size.width

@interface RMyFootView ()

@property (nonatomic ,strong) UIButton *commenteBtn;
@property (nonatomic ,strong) UIButton *shareBtn;
@end

@implementation RMyFootView

-(UIButton *)commenteBtn{
    if (_commenteBtn == nil) {
        _commenteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commenteBtn setImage:[UIImage imageNamed:@"commente_btn"] forState:UIControlStateNormal];
        [_commenteBtn setImage:[UIImage imageNamed:@"commente_btn_s"] forState:UIControlStateHighlighted];
        _commenteBtn.tag = 1001;
        [_commenteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _commenteBtn;
}
-(UIButton *)shareBtn{
    if (_shareBtn == nil) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
        [_shareBtn setImage:[UIImage imageNamed:@"share_btn_s"] forState:UIControlStateHighlighted];
        _shareBtn.tag = 1002;
        [_shareBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _shareBtn;
}



- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.commenteBtn];
        [self.contentView addSubview:self.shareBtn];
        //设置约束
        
        [self.commenteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(@40);
            make.centerX.mas_equalTo(-(RScreenW/4.0));
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        
        [self.shareBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(RScreenW/4.0);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        
        
    }
    return self;
}


-(void)btnClick:(UIButton *)sender{
    if (_changedSelectedBtn) {
        _changedSelectedBtn(sender.tag);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
