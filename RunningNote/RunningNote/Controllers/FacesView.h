//
//  FacesView.h
//  Yueba
//
//  Created by qingyun on 16/7/23.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FaceModel;

typedef void (^SelectedFace) (FaceModel *face);

@interface FacesView : UIView

@property (nonatomic, copy)SelectedFace selectedFace;//回调block;

@end
