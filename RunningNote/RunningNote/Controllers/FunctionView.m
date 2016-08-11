
//
//  FunctionView.m
//  Yueba
//
//  Created by qingyun on 16/7/23.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "FunctionView.h"

@implementation FunctionView

- (void)awakeFromNib{
    _selectImage.layer.cornerRadius = 30;
    _selectImage.clipsToBounds = YES;
}
- (IBAction)buttonPress:(UIButton *)sender {
    
    [self.delegate  selectAction:sender.tag];
    
}


@end




