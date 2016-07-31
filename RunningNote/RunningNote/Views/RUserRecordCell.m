//
//  RUserRecordCell.m
//  RunningNote
//
//  Created by qingyun on 16/7/28.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RUserRecordCell.h"
#import "RUserRunRecord.h"

@interface RUserRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *speed;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UISegmentedControl *isHomeSegment;

@end

@implementation RUserRecordCell

- (void)setRecoedModel:(RUserRunRecord *)recoedModel {
    _recoedModel = recoedModel;
    _title.text = recoedModel.title;
    _speed.text = [NSString stringWithFormat:@"%g",recoedModel.speed];
    _time.text = recoedModel.time;
    _distance.text = [NSString stringWithFormat:@"%g",recoedModel.distance];
    _isHomeSegment.selectedSegmentIndex = recoedModel.isHome;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImageView *imageView;
    if ([self.reuseIdentifier isEqualToString:@"recordCellHome"]) {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_record_cell"]];
    }else {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_record_cellout"]];
    }
    
    [self setBackgroundView:imageView];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
