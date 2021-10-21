//
//  JPPackageMenuView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/3/24.
//  Copyright © 2017年 MuXiao. All rights reserved.
//
#import "JPUtil.h"
#import "JPPackageTextPatternMenuView.h"
#import "JPHorizontalCollectionViewLayout.h"
#import "JPPackageTextPatternMenuCell.h"
#import <SDCycleScrollView/TAPageControl.h>
#import "JPFontModel.h"


@interface JPPackageTextPatternMenuView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,
  JPHorizontalCollectionViewLayoutDelegate>{
    UICollectionView *collecView;
    TAPageControl *pageControl;
    NSMutableArray *dataArr;
}

- (void)createUI;

@end

@implementation JPPackageTextPatternMenuView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        dataArr = [NSMutableArray array];
        for (NSInteger index = 0; index < 10; index ++) {
            JPPackagePatternAttribute *attribute = [[JPPackagePatternAttribute alloc] init];
            attribute.thumImageIfFromBundle = YES;
            switch (index) {
                case 0:
                    attribute.patternType = JPPackagePatternTypeTextWithNone;
                    attribute.thumPictureName = @"f01";
                    attribute.text = @"双击输入";
                    attribute.textColor = [UIColor whiteColor];
                    attribute.patternName = @"F01";
                    attribute.textFontSize = 18;
                    attribute.textFontName = [JPFontModel getFontNameWithType:JPTextFontTypePingFang];
                    break;
                case 1:
                    attribute.patternType = JPPackagePatternTypeTextWithPinyin;
                    attribute.thumPictureName = @"f03";
                    attribute.text = @"双击输入";
                    attribute.patternName = @"F03";
                    attribute.textColor = [UIColor whiteColor];
                    attribute.textFontSize = 14;
                    attribute.textFontName = [JPFontModel getFontNameWithType:JPTextFontTypePingFang];
                    break;
                case 2:
                    attribute.patternType = JPPackagePatternTypeTextWithBackgroundColor;
                    attribute.thumPictureName = @"f02";
                    attribute.text = @"双击输入";
                    attribute.textColor = [UIColor whiteColor];
                    attribute.backgroundColor = [UIColor jp_colorWithHexString:@"fb1b45"];
                    attribute.selectColorIndex = 0;
                    attribute.patternName = @"F02";
                    attribute.selectBackColorIndex = 2;
                    attribute.textFontName = [JPFontModel getFontNameWithType:JPTextFontTypePingFang];
                    attribute.textFontSize = 18;
                    break;
                case 3:
                    attribute.patternType = JPPackagePatternTypeTextWithBorderLine;
                    attribute.thumPictureName = @"f05";
                    attribute.text = @"双击输入";
                    attribute.textColor = [UIColor whiteColor];
                    attribute.selectColorIndex = 0;
                    attribute.patternName = @"F05";
                    attribute.textFontSize = 18;
                    attribute.textFontName = [JPFontModel getFontNameWithType:JPTextFontTypePingFang];
                    break;
                case 4:
                    attribute.patternType = JPPackagePatternTypeTextWithUpAndDownLine;
                    attribute.thumPictureName = @"f04";
                    attribute.text = @"双击输入";
                    attribute.textColor = [UIColor whiteColor];
                    attribute.selectColorIndex = 0;
                    attribute.patternName = @"f04";
                    attribute.textFontName = [JPFontModel getFontNameWithType:JPTextFontTypePingFang];
                    attribute.textFontSize = 18;
                    break;
                case 5:
                    attribute.patternType = JPPackagePatternTypeSixthTextPattern;
                    attribute.thumPictureName = @"f06";
                    attribute.text = @"双击输入";
                    attribute.subTitle = @"添加副标题";
                    attribute.textColor = [UIColor whiteColor];
                    attribute.backgroundColor = [UIColor jp_colorWithHexString:@"0091FF"];
                    attribute.selectColorIndex = 0;
                    attribute.selectBackColorIndex = 4;
                    attribute.patternName = @"F06";
                    attribute.textFontSize = 15;
                    attribute.textFontName = [JPFontModel getFontNameWithType:JPTextFontTypePingFang];
                    break;
                case 6:
                    attribute.patternType = JPPackagePatternTypeSeventhTextPattern;
                    attribute.thumPictureName = @"f07";
                    attribute.text = @"双击输入";
                    attribute.patternName = @"F07";
                    attribute.textColor = [UIColor whiteColor];
                    attribute.selectColorIndex = 0;
                    attribute.selectBackColorIndex = 2;
                    attribute.backgroundColor = [UIColor jp_colorWithHexString:@"fb1b45"];
                    attribute.textFontSize = 15;
                    attribute.textFontName = [JPFontModel getFontNameWithType:JPTextFontTypePingFang];
                    break;
                case 7:
                    attribute.patternType = JPPackagePatternTypeEighthTextPattern;
                    attribute.thumPictureName = @"f08";
                    attribute.text = @"双击输入";
                    attribute.textColor = [UIColor whiteColor];
                    attribute.patternName = @"F08";
                    attribute.logoImageIfFromBundle = YES;
                    attribute.logoImageFilePath = @"loginIcon";
                    attribute.textFontName = [JPFontModel getFontNameWithType:JPTextFontTypePingFang];
                    attribute.textFontSize = 15;
                    break;
                case 8:
                    attribute.patternType = JPPackagePatternTypeNinthTextPattern;
                    attribute.thumPictureName = @"f09";
                    attribute.text = @"双击输入";
                    attribute.subTitle = @"添加副标题";
                    attribute.textColor = [UIColor whiteColor];
                    attribute.selectColorIndex = 0;
                    attribute.patternName = @"F09";
                    attribute.textFontSize = 15;
                    attribute.textFontName = [JPFontModel getFontNameWithType:JPTextFontTypePingFang];
                    break;
                case 9:
                    attribute.patternType = JPPackagePatternTypeTenthTextPattern;
                    attribute.thumPictureName = @"f10";
                    attribute.text = @"双击输入";
                    attribute.subTitle = @"添加副标题";
                    attribute.textColor = [UIColor whiteColor];
                    attribute.selectColorIndex = 0;
                    attribute.selectBackColorIndex = 8;
                    attribute.backgroundColor = [UIColor jp_colorWithHexString:@"7e14e0"];
                    attribute.patternName = @"F10";
                    attribute.textFontName = [JPFontModel getFontNameWithType:JPTextFontTypePingFang];
                    attribute.textFontSize = 15;
                    break;
                default:
                    break;
            }
            [dataArr addObject:attribute];
        }
        [self createUI];
        [self setTittle:@"文字压条"];
    }
    return self;
}

#pragma mark JPHorizontalCollectionViewLayoutDelegate

- (void)horizontalCollectionViewLayout:(JPHorizontalCollectionViewLayout *)layout currentPage:(NSInteger)currentPage
{
    pageControl.numberOfPages = currentPage;
    NSInteger index = collecView.contentOffset.x / collecView.width;
    pageControl.currentPage = index;
}

#pragma mark - public methods

- (void)createUI {
    JPHorizontalCollectionViewLayout * layout = [[JPHorizontalCollectionViewLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.layoutDelegate = self;
    layout.pageChangeDelegate = self;
    collecView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0 , JP_SCREEN_WIDTH ,self.height - 80) collectionViewLayout:layout];
    collecView.delegate = self;
    collecView.backgroundColor = self.backgroundColor;
    collecView.dataSource = self;
    collecView.pagingEnabled = YES;
    collecView.scrollEnabled = YES;
    collecView.bounces = NO;
    collecView.showsHorizontalScrollIndicator = NO;
    collecView.showsVerticalScrollIndicator = NO;
    [collecView registerClass:[JPPackageTextPatternMenuCell class] forCellWithReuseIdentifier:@"JPPackageTextPatternMenuCell"];
    [self addSubview:collecView];
    
    pageControl = [[TAPageControl alloc] init];
    pageControl.numberOfPages = 1;
    pageControl.dotColor = [UIColor whiteColor];
    [self addSubview:pageControl];
    
    pageControl.sd_layout.centerXEqualToView(self).bottomSpaceToView(self, 20).widthRatioToView(self, 1.0).heightIs(1);
    collecView.sd_layout.bottomSpaceToView(pageControl, 8).centerXEqualToView(self).widthRatioToView(self, 1.0).topSpaceToView(self.tittleView, 13);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JPPackagePatternAttribute *attribute = dataArr[indexPath.row];
    JPPackageTextPatternMenuCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPPackageTextPatternMenuCell" forIndexPath:indexPath];
    cell.patternAttribute = attribute;;
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = collecView.contentOffset.x / collecView.width;
    pageControl.currentPage = index;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JPPackagePatternAttribute *attribute = [dataArr objectAtIndex:indexPath.row];
    if (self.delegate) {
        [self.delegate packageTextPatternMenuViewSelectedGraphWithData:attribute];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((JP_SCREEN_WIDTH)/3, 60);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}

#pragma mark - actions 

- (void)dismiss {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hideTextMenu)]) {
        [self.delegate hideTextMenu];
    }
}

@end
