//
//  RDynamicModel.h
//  RunningNote
//
//  Created by qingyun on 16/7/13.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDynamicModel : NSObject

@property (nonatomic, copy) NSString *userName;//用户名
@property (nonatomic, copy) NSString *objectid;//用户ID
@property (nonatomic, copy) NSString *body;//发表的文字内容
@property (nonatomic, strong)NSData  *images;//发表的图片内容
@property (nonatomic, strong)NSDate  *createdAt;//创建时间
@property (nonatomic, copy) NSString *location;//位置信息
@property (nonatomic, strong)NSArray *comments;//包含评论的数组



+(instancetype)modelWithResults:(id)results;
-(instancetype)initWithResults:(id)results;

@end
