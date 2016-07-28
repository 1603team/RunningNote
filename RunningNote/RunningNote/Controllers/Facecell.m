//
//  Facecell.m
//  Yueba
//
//  Created by qingyun on 16/7/25.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "Facecell.h"
#import "FaceModel.h"

@implementation Facecell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)banddingFaceModel:(FaceModel*)face{
    //绑定模型
    if (face.imgName != nil) {
        self.imageView.image = [UIImage imageNamed:face.imgName];
    }else{
        self.imageView.image = nil;
    }
}

@end
