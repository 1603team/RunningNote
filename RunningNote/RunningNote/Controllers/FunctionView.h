//
//  FunctionView.h
//  Yueba
//
//  Created by qingyun on 16/7/23.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void (^SelectedFunction) (NSInteger tapNumber);

@protocol FuncitonDelegate <NSObject>
//代理传递点击button的tag值
-(void)selectAction:(NSInteger )actionIndex;

@end


@interface FunctionView : UIView
@property (weak, nonatomic) IBOutlet UIButton *phoneImage;
@property (weak, nonatomic) IBOutlet UIButton *selectImage;
@property (weak, nonatomic) IBOutlet UIButton *shareLocation;

@property (nonatomic, weak)   id <FuncitonDelegate> delegate;


- (IBAction)buttonPress:(UIButton *)sender;

@end
