//
//  Facecell.h
//  Yueba
//
//  Created by qingyun on 16/7/25.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <UIKit/UIKit.h>


//


@class FaceModel;
@interface Facecell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;



-(void)banddingFaceModel:(FaceModel*)face;

@end
