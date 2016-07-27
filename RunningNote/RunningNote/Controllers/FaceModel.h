//
//  FaceModel.h
//  Yueba
//
//  Created by qingyun on 16/7/23.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceModel : NSObject

@property (nonatomic, strong)NSString *text;//文本表情
@property (nonatomic, strong)NSString *imgName;//图片的名字,如果没有图片,则为占位
@property (nonatomic)BOOL isBack;//回退按钮


-(instancetype)initWithDict:(NSDictionary *)dict;

@end
