//
//  FacesView.m
//  Yueba
//
//  Created by qingyun on 16/7/23.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "FacesView.h"
#import "FaceModel.h"
#import "Facecell.h"

#define kFaceWith 60
#define kFaceHeight 40
#define kScreenW [[UIScreen mainScreen] bounds].size.width

@interface FacesView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic)NSInteger columns;//每页列数
@property (nonatomic)NSInteger lines;//每页的行数
@property (nonatomic)NSInteger page;//多少页

@property (nonatomic, strong)NSArray *faces;//表情模型数组
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation FacesView



-(void)awakeFromNib{
    _columns = kScreenW / kFaceWith;
    _lines = (self.bounds.size.height - 14) / kFaceHeight;
    //加载数据
    [self loadFace];
    _page = self.faces.count/(_columns * _lines);
    
    //配置collectionView
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    UINib *nib = [UINib nibWithNibName:@"Facecell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"facecell"];
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *) _collectionView.collectionViewLayout;
    flow.itemSize = CGSizeMake(kScreenW/_columns, (self.bounds.size.height - 14)/ _lines);
    _collectionView.pagingEnabled = YES;
    _pageControl.numberOfPages = _page;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
}

-(void)loadFace{
    //从plist中读取文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Faces" ofType:@"plist"];
    NSDictionary *faceDict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *tt = faceDict[@"TT"];//tt表情数组
    NSMutableArray *faceMu = [NSMutableArray array];
    //每页多少个
    NSInteger pageCount = _lines * _columns;
    for (int i = 0; i < tt.count; i ++) {
        NSDictionary *faceInfo = tt[i];
        //如果到最后一个添加一个回退按钮
        if (i % (pageCount -1) == 0 && i != 0) {
            [faceMu addObject:[self createdBackModel]];
        }
        FaceModel *model = [[FaceModel alloc] initWithDict:faceInfo];
        [faceMu addObject:model];
    }
    //把最后一页补满
    //最后一页剩余几个
    NSInteger last = faceMu.count % pageCount;
    //还差几个,最后一个添加的是back
    for (int i = 0; i < (pageCount - last - 1); i ++) {
        FaceModel *model = [[FaceModel alloc] init];
        [faceMu addObject:model];
    }
    [faceMu addObject:[self createdBackModel]];
    _faces = faceMu;
}

-(FaceModel*)createdBackModel{
    //初始化一个back表情模型
    FaceModel *back = [[FaceModel alloc] init];
    back.imgName = @"ic_back_emojis";
    back.isBack = YES;
    return back;
}

#pragma mark -collection datasource delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _page * _columns;//页数乘以每页列数
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _lines;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Facecell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"facecell" forIndexPath:indexPath];
    
    //找到item对应数据源中的索引
    NSInteger idx = (indexPath.section / _columns)* (_columns * _lines) + indexPath.section % _columns + indexPath.row * _columns;
    
    FaceModel *model = self.faces[idx];
    [cell banddingFaceModel:model];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //找到对应模型数组中的索引
    NSInteger idx = (indexPath.section / _columns)* (_columns * _lines) + indexPath.section % _columns + indexPath.row * _columns;
    FaceModel *face = self.faces[idx];
    //回调,通知结果
    self.selectedFace(face);
}

//scorll减速结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.pageControl.currentPage = scrollView.contentOffset.x /kScreenW;
}

@end
