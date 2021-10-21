//
//  JPPackageMenuAttributeView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/3/29.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackagePatternAttributeView.h"
#import "JPPackageMenuAttributeColorCell.h"
#import "JPPackageMenuAttributePhotoCell.h"
#import "JPPackageMenuAttributeTimeSliderCell.h"
#import "JPTextFontSizeCollectionViewCell.h"
#import "JPPackageMenuAttributeTextFontCell.h"
#import "TAPageControl.h"
#import "JPUtil.h"

@interface JPPackagePatternAttributeView()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,JPPackageMenuAttributeTimeSliderCellDelelgate>{
    UICollectionView *collecView;
    NSMutableArray *dataArr;
    JPPackagePatternAttribute *patternAttribute;
    CMTime videoduration;
}
@property (nonatomic, strong) JPVideoCompositionPlayer *compostionPlayer;
- (void)createUI;

@end

@implementation JPPackagePatternAttributeView

- (JPPackagePatternAttribute *)patternAttributeModel
{
    return patternAttribute;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        dataArr = [NSMutableArray array];
        [self createUI];
    }
    return self;
}

- (void)updateViewWithType:(JPPackagePatternAttribute *)attribute andVideoCompositon:(JPVideoCompositionPlayer *)compositonPlayer{
    NSString *tittle = @"文字属性";
    _compostionPlayer = compositonPlayer;
    videoduration = compositonPlayer.recordInfo.totalVideoDuraion;
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObjectsFromArray:@[@(JPPackagePatternAttributeTypeTimeRange),@(JPPackagePatternAttributeTypeFontColor),@(JPPackagePatternAttributeTypeTextFont),@(JPPackagePatternAttributeTypeTextFontSize)]];
//        JPPackagePatternTypeWeather = 0,//天气
//        JPPackagePatternTypeDate,//日期
//        JPPackagePatternTypePosition,//位置
//        JPPackagePatternTypePicture
    if (attribute.patternType == JPPackagePatternTypeWeather || attribute.patternType == JPPackagePatternTypeDate || attribute.patternType == JPPackagePatternTypePosition || attribute.patternType == JPPackagePatternTypePicture  || attribute.patternType == JPPackagePatternTypeHollowOutPicture || attribute.patternType == JPPackagePatternTypeWeekPicture || attribute.patternType == JPPackagePatternTypeDownloadedPicture || attribute.patternType == JPPackagePatternTypeGifPattern) {
        tittle = @"图案属性";
        arr = @[@(JPPackagePatternAttributeTypeTimeRange)].mutableCopy;
    }
    patternAttribute = attribute;
    [_compostionPlayer scrollToWatchThumImageWithTime:patternAttribute.timeRange.start withSticker:NO];
    switch (patternAttribute.patternType) {
            case JPPackagePatternTypeTextWithNone:
            break;
            case JPPackagePatternTypeTextWithBackgroundColor:
            case JPPackagePatternTypeSixthTextPattern:
            case JPPackagePatternTypeSeventhTextPattern:
            case JPPackagePatternTypeTenthTextPattern:
            [arr insertObject:@(JPPackagePatternAttributeTypeBackgroundColor) atIndex:2];
            break;
        case JPPackagePatternTypeTextWithLogoAndLine:
            [arr addObject:@(JPPackagePatternAttributeTypePhoto)];
            break;
        case JPPackagePatternTypeEighthTextPattern:
            [arr addObject:@(JPPackagePatternAttributeTypePhoto)];
            break;
        default:
            break;
    }
    dataArr = arr.mutableCopy;
    [self setTittle:tittle];
    [collecView reloadData];
}

#pragma mark - public methods

- (void)createUI {
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collecView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0 , JP_SCREEN_WIDTH ,self.height - 80) collectionViewLayout:layout];
    collecView.delegate = self;
    collecView.backgroundColor = self.backgroundColor;
    collecView.dataSource = self;
    collecView.scrollEnabled = YES;
    collecView.showsHorizontalScrollIndicator = NO;
    collecView.showsVerticalScrollIndicator = NO;
    [collecView registerClass:[JPPackageMenuAttributeColorCell class] forCellWithReuseIdentifier:@"JPPackageMenuAttributeColorCell"];
    [collecView registerClass:[JPPackageMenuAttributePhotoCell class] forCellWithReuseIdentifier:@"JPPackageMenuAttributePhotoCell"];
    [collecView registerClass:[JPPackageMenuAttributeTimeSliderCell class] forCellWithReuseIdentifier:@"JPPackageMenuAttributeTimeSliderCell"];
    [collecView registerNib:[UINib nibWithNibName:@"JPTextFontCollectionViewCell" bundle:JPResourceBundle] forCellWithReuseIdentifier:@"JPTextFontSizeCollectionViewCell"];
    [collecView registerClass:[JPPackageMenuAttributeTextFontCell class] forCellWithReuseIdentifier:@"JPPackageMenuAttributeTextFontCell"];
    [self addSubview:collecView];
    collecView.sd_layout.bottomSpaceToView(self, 0).centerXEqualToView(self).widthRatioToView(self, 1.0).topSpaceToView(self.tittleView, 10);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [dataArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JPPackagePatternAttributeType type = (JPPackagePatternAttributeType)[[dataArr objectAtIndex:indexPath.row] intValue];
    if (JPPackagePatternAttributeTypeBackgroundColor == type){
        JPPackageMenuAttributeColorCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPPackageMenuAttributeColorCell" forIndexPath:indexPath];
        cell.textLb.text = @"背景颜色";
        cell.attributeType = JPPackagePatternAttributeTypeBackgroundColor;
        cell.patternInteractiveView = self.apearView;

        return cell;
    } else if (JPPackagePatternAttributeTypeFontColor == type){
        JPPackageMenuAttributeColorCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPPackageMenuAttributeColorCell" forIndexPath:indexPath];
        cell.textLb.text = @"字体颜色";
        cell.attributeType = JPPackagePatternAttributeTypeFontColor;
        cell.patternInteractiveView = self.apearView;

        return cell;
    }else if (JPPackagePatternAttributeTypePhoto == type){
        JPPackageMenuAttributePhotoCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPPackageMenuAttributePhotoCell" forIndexPath:indexPath];
        cell.patternInteractiveView = self.apearView;

        return cell;
    } else if (JPPackagePatternAttributeTypeTimeRange == type) {
        JPPackageMenuAttributeTimeSliderCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPPackageMenuAttributeTimeSliderCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell updateSliderWithMinValue:0.f
                           andMaxValue:CMTimeGetSeconds(videoduration)
                          andLeftValue:CMTimeGetSeconds(patternAttribute.timeRange.start)
                         andRightVlaue:CMTimeGetSeconds(patternAttribute.timeRange.duration) + CMTimeGetSeconds(patternAttribute.timeRange.start)];
        cell.patternInteractiveView = self.apearView;
        return cell;
    }else if (JPPackagePatternAttributeTypeTextFontSize == type){
        JPTextFontSizeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPTextFontSizeCollectionViewCell" forIndexPath:indexPath];
        cell.patternInteractiveView = self.apearView;
        return cell;
    }else if (JPPackagePatternAttributeTypeTextFont == type){
        JPPackageMenuAttributeTextFontCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPPackageMenuAttributeTextFontCell" forIndexPath:indexPath];
        cell.patternInteractiveView = self.apearView;
        return cell;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *typeNumber = dataArr[indexPath.row];
    JPPackagePatternAttributeType type = typeNumber.integerValue;
    if (type == JPPackagePatternAttributeTypePhoto || type == JPPackagePatternAttributeTypeTextFont)
    {
        return CGSizeMake(JP_SCREEN_WIDTH, 74);
    }else if (type == JPPackagePatternAttributeTypeTimeRange)
    {
        return CGSizeMake(JP_SCREEN_WIDTH, 90);

    }else{
        return CGSizeMake(JP_SCREEN_WIDTH, 49);

    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}

#pragma mark - JPPackageMenuAttributeTimeSliderCellDelelgate

- (void)rangeSliderValueDidChangeWithLeftValue:(CGFloat)left andRightValue:(CGFloat)right {

    CMTimeRange timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(left, 24),CMTimeMakeWithSeconds(right - left, 24));
    if (CMTimeCompare(patternAttribute.timeRange.start, timeRange.start) == 0 && CMTimeCompare(patternAttribute.timeRange.duration, timeRange.duration) != 0) {
        [_compostionPlayer scrollToWatchThumImageWithTime:CMTimeAdd(timeRange.duration, timeRange.start) withSticker:NO];
    }else if(CMTimeCompare(patternAttribute.timeRange.start, timeRange.start) != 0){
        [_compostionPlayer scrollToWatchThumImageWithTime:timeRange.start withSticker:NO];
    }
    patternAttribute.timeRange = timeRange;
}

- (void)rangeSliderValueDidEndChangeWithLeftValue:(CGFloat)left andRightValue:(CGFloat)right
{
    CMTimeRange timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(left, 24),CMTimeMakeWithSeconds(right - left, 24));
    [_compostionPlayer scrollToWatchThumImageWithTime:timeRange.start withSticker:NO];
    patternAttribute.timeRange = timeRange;

}
#pragma mark - actions

- (void)comfirm:(id)sender {
    [self dismiss];
}

- (UIView *)timeView
{
    JPPackageMenuAttributeTimeSliderCell *sliderCell = (JPPackageMenuAttributeTimeSliderCell *)[collecView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    if (sliderCell && [sliderCell isKindOfClass:[JPPackageMenuAttributeTimeSliderCell class]]) {
        return sliderCell.pointView;
    }
    return nil;
}
- (void)dismiss
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(patternAttributeViewWillHide)]) {
        [self.delegate patternAttributeViewWillHide];
    }
  }
@end
