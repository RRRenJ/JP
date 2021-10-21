//
//  JPLocalTextView.m
//  jper
//
//  Created by FoundaoTEST on 2017/8/1.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPLocalTextView.h"
#import "JPFontModel.h"
#import "JPStickerPictureCollectionViewCell.h"
#import "UIImageView+JPScorllView.h"
@interface JPLocalTextView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *collecView;
    NSMutableArray *dataArr;

}
@end

@implementation JPLocalTextView
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

     
    }
    return self;
}

#pragma mark - public methods

- (void)createUI {
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 0;
    
    //设置布局方向为垂直流布局
    collecView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 13 , JP_SCREEN_WIDTH ,self.height - 80) collectionViewLayout:layout];
    collecView.tag = noDisableVerticalScrollTag;
    collecView.delegate = self;
    collecView.backgroundColor = self.backgroundColor;
    collecView.dataSource = self;
    collecView.showsVerticalScrollIndicator = NO;
    collecView.showsHorizontalScrollIndicator = NO;
    collecView.scrollEnabled = YES;
    collecView.bounces = YES;
    collecView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [collecView registerNib:[UINib nibWithNibName:@"JPStickerPictureCollectionViewCell" bundle:JPResourceBundle] forCellWithReuseIdentifier:@"JPStickerPictureCollectionViewCell"];
    [self addSubview:collecView];
    collecView.sd_layout.bottomSpaceToView(self, 0).leftEqualToView(self).rightEqualToView(self).topSpaceToView(self,0);
    [collecView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [collecView flashScrollIndicators];
    });
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [dataArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        JPPackagePatternAttribute *attribute = [dataArr objectAtIndex:indexPath.row];
        JPStickerPictureCollectionViewCell *celll = nil;
    celll = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPStickerPictureCollectionViewCell" forIndexPath:indexPath];
    celll.imgViewWidthLayoutConstraint.constant = celll.imgViewHeightLayoutConstraint.constant = 35;
    celll.imgView.image = attribute.thumPicture;
    return celll;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(localTextViewSelectedGraphWithData:)]) {
        [self.delegate localTextViewSelectedGraphWithData:[dataArr objectAtIndex:indexPath.row]];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.width/3, 60);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}


@end
