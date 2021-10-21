//
//  JPGifListView.m
//  jper
//
//  Created by FoundaoTEST on 2017/11/14.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPGifListView.h"

#import "JPGifListCellCollectionViewCell.h"


@interface JPGifListView()<UICollectionViewDelegate,UICollectionViewDataSource>{
    UICollectionView *collecView;
    NSMutableArray *dataArr;
}

- (void)createUI;
- (NSMutableArray *)getGifPicture;
@end
@implementation JPGifListView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        dataArr =  [self getGifPicture];
        [self createUI];
    }
    return self;
}

- (NSMutableArray *)getGifPicture
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *baseData = [NSArray arrayWithContentsOfURL:[JPResourceBundle URLForResource:@"gif_pngs" withExtension:@"plist"] ];
    for (NSInteger index = 0; index < baseData.count; index ++) {
        NSString *number = [NSString stringWithFormat:@"%ld", (long)index];
        while (number.length < 2) {
            number = [NSString stringWithFormat:@"0%@_", number];
        }
        JPPackagePatternAttribute *attribute = [[JPPackagePatternAttribute alloc] init];
        attribute.patternType = JPPackagePatternTypeGifPattern;
        attribute.patternName = [NSString stringWithFormat:@"PPP%@", number];
        NSDictionary *dic = baseData[index];
        attribute.gifPNGCount = [dic[@"gifPNGCount"] integerValue];
        attribute.secondOfFrame = [dic[@"secondOfFrame"] integerValue];
        attribute.firstPNGName = dic[@"firstPNGName"];
        attribute.thumFirstPNGName = dic[@"thumFirstPNGName"];
        attribute.frame = CGRectMake(50, 50, attribute.gifImageSize.width + 26, attribute.gifImageSize.height + 26);
        [array addObject:attribute];
    }
    return array;
}


- (void)createUI {
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 0;
    
    //设置布局方向为垂直流布局
    collecView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 13 , JP_SCREEN_WIDTH ,self.height - 80) collectionViewLayout:layout];
    collecView.delegate = self;
    collecView.backgroundColor = self.backgroundColor;
    collecView.dataSource = self;
    collecView.showsVerticalScrollIndicator = NO;
    collecView.showsHorizontalScrollIndicator = NO;
    collecView.scrollEnabled = YES;
    collecView.bounces = YES;
    collecView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    //    collecView.showsHorizontalScrollIndicator = YES;
    //    collecView.showsVerticalScrollIndicator = YES;
    [collecView registerClass:[JPGifListCellCollectionViewCell class] forCellWithReuseIdentifier:@"JPGifListCellCollectionViewCell"];
    [self addSubview:collecView];
    collecView.sd_layout.bottomSpaceToView(self, 0).leftEqualToView(self).rightEqualToView(self).topSpaceToView(self,0);
    [collecView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [dataArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JPGifListCellCollectionViewCell *cell = [collecView dequeueReusableCellWithReuseIdentifier:@"JPGifListCellCollectionViewCell" forIndexPath:indexPath];
    cell.patternAttribute = dataArr[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedGifGraphWithData:)]) {
        [self.delegate selectedGifGraphWithData:dataArr[indexPath.row]];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(JPScreenFitFloat6(60), JPScreenFitFloat6(60));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat f = (JP_SCREEN_WIDTH - JPScreenFitFloat6(60)*4 - 30)/8.f;
    return UIEdgeInsetsMake(f, f, f, f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return (JP_SCREEN_WIDTH - JPScreenFitFloat6(60)*4 - 30)/8.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return (JP_SCREEN_WIDTH - JPScreenFitFloat6(60)*4 - 30)/8.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (void)show
{
    for (JPGifListCellCollectionViewCell *cell in collecView.visibleCells) {
        [cell startAnimation];
    }
}

- (void)dismiss
{
    for (JPGifListCellCollectionViewCell *cell in collecView.visibleCells) {
        [cell stopAnimation];
    }
}
@end
