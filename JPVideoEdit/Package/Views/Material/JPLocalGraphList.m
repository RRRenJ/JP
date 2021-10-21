//
//  JPLocalGraphList.m
//  jper
//
//  Created by 藩 亜玲 on 2017/7/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPLocalGraphList.h"
#import "JPPackagePictureGraphCell.h"
#import "JPPackageGraphMenuCell.h"
#import "JPUtil.h"
#import "JPStickerPictureCollectionViewCell.h"
#import "JPPackagePictureGraphView.h"
#import "JPPackageGraphView.h"
#import "UIImageView+JPScorllView.h"
@interface JPLocalGraphList()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,JPPackagePictureGraphCellDelegate>{
    UICollectionView *collecView;
    NSMutableArray *dataArr;
}

- (void)createUI;
- (NSArray *)getAllWeekPicture;
@end

@implementation JPLocalGraphList

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        dataArr = [NSMutableArray array];
//        JPPackagePatternAttribute *attribute = [[JPPackagePatternAttribute alloc] init];
//        attribute.patternType = JPPackagePatternTypeWeather;
//        attribute.patternName = @"P01";
//        attribute.thumImageIfFromBundle = YES;
//        attribute.thumPictureName = @"temperature";
//        [dataArr addObject:attribute];
//
//        attribute = [[JPPackagePatternAttribute alloc] init];
//        attribute.patternType = JPPackagePatternTypePosition;
//        attribute.patternName = @"P02";
//        attribute.text = [JPSession sharedInstance].cityName;
//        attribute.textFontSize = 18;
//        attribute.textFontName = @".SFUIText";
//        attribute.thumImageIfFromBundle = YES;
//        attribute.thumPictureName = @"position-1";
//        [dataArr addObject:attribute];
//
//        attribute = [[JPPackagePatternAttribute alloc] init];
//        attribute.patternType = JPPackagePatternTypeDate;
//        attribute.patternName = @"P03";
//        attribute.text = [JPSession sharedInstance].cityName;
//        attribute.textFontSize = 18;
//        attribute.textFontName = @".SFUIText";
//        attribute.thumImageIfFromBundle = YES;
//        attribute.thumPictureName = @"date-temp";
//        [dataArr addObject:attribute];
        [dataArr addObjectsFromArray:[self getAllWeekPicture]];
        [self createUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPicture:) name:FINISHSELECTEDPICTURENOTIFICATION object:nil];
    }
    return self;
}



- (NSArray *)getAllWeekPicture
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger index = 1; index <= 14; index ++) {
        @autoreleasepool {
            
//            attr.originImagePath = material.absoluteLocalPath;
//            attr.patternName = material.name;
//            attr.thumImageUrl = material.icon;
//            UIImage *img = [UIImage imageWithContentsOfFile:material.absoluteLocalPath];
//            CGSize size = img.size;
//            attr.originImgSize = CGSizeMake(size.width/2.0, size.height/2.0);

            JPPackagePatternAttribute * attribute = [[JPPackagePatternAttribute alloc] init];
            attribute.patternType = JPPackagePatternTypeDownloadedPicture;
            NSString *numberStr = [NSString stringWithFormat:@"PPP%ld", index];
            attribute.thumPictureName = [NSString stringWithFormat:@"%@s", numberStr];
            attribute.thumImageIfFromBundle = YES;
            attribute.originImageName = numberStr;
            attribute.thumImageUrlName = [NSString stringWithFormat:@"%@s.png", numberStr] ;
            attribute.thumImageUrlNameFromBundle = YES;
            CGSize size =attribute.originImage.size;
            attribute.originImgSize = CGSizeMake(size.width/2.0, size.height/2.0);
            numberStr = [NSString stringWithFormat:@"P0%ld", index + 4];
            if ((index + 5) >= 10) {
                numberStr = [NSString stringWithFormat:@"P%ld", index + 4];
            }
            attribute.patternName = numberStr;
            attribute.frame = CGRectMake(50, 50, attribute.originImgSize.width/5 + 26, attribute.originImgSize.height/5 + 26);
            [array addObject:attribute];
        }
    }
    
    return array;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FINISHSELECTEDPICTURENOTIFICATION object:nil];
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
//    collecView.showsHorizontalScrollIndicator = YES;
//    collecView.showsVerticalScrollIndicator = YES;
    [collecView registerClass:[JPPackagePictureGraphCell class] forCellWithReuseIdentifier:@"JPPackagePictureGraphCell"];
    [collecView registerClass:[JPPackageGraphMenuCell class] forCellWithReuseIdentifier:@"JPPackageGraphMenuCell"];
    [collecView registerNib:[UINib nibWithNibName:@"JPStickerPictureCollectionViewCell" bundle:JPResourceBundle] forCellWithReuseIdentifier:@"JPStickerPictureCollectionViewCell"];
    [self addSubview:collecView];
    collecView.sd_layout.bottomSpaceToView(self, 0).leftEqualToView(self).rightEqualToView(self).topSpaceToView(self,0);
    [collecView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self->collecView flashScrollIndicators];
    });
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *view = [super hitTest:point withEvent:event];
//    if (view) {
//        [collecView flashScrollIndicators];
//    }
//    return view;
//}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [dataArr count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [dataArr count]) {
        JPPackagePictureGraphCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPPackagePictureGraphCell" forIndexPath:indexPath];
        cell.imgView.userInteractionEnabled = NO;
        cell.imgView.image = JPImageWithName(@"add_picture");
        cell.showDeleteBtn = NO;
        cell.deleteBtn.tag = indexPath.row;
        cell.delegate = self;
        return cell;
    } else {
        JPPackagePatternAttribute *attribute = [dataArr objectAtIndex:indexPath.row];
        JPPackagePictureGraphCell *cel = nil;
        JPStickerPictureCollectionViewCell *celll = nil;
        switch (attribute.patternType) {
            case JPPackagePatternTypePosition:
            case JPPackagePatternTypeDate:
            case JPPackagePatternTypeWeather:
            case JPPackagePatternTypeDownloadedPicture:
                celll = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPStickerPictureCollectionViewCell" forIndexPath:indexPath];
                celll.imgView.image = attribute.thumPicture;
                celll.imgViewWidthLayoutConstraint.constant = celll.imgViewHeightLayoutConstraint.constant = 60;
                return celll;
                break;
            case JPPackagePatternTypePicture:
                cel = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPPackagePictureGraphCell" forIndexPath:indexPath];
                celll.imgViewWidthLayoutConstraint.constant = celll.imgViewHeightLayoutConstraint.constant = 35;
                cel.imgView.image = attribute.thumPicture;
                cel.imgView.userInteractionEnabled = YES;
                cel.showDeleteBtn = YES;
                cel.deleteBtn.tag = indexPath.row;
                cel.delegate = self;
                return cel;
                break;
            default:
                break;
        }
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [dataArr count]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(toPicturePickerView)]) {
            [self.delegate toPicturePickerView];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectedGraphWithData:)]) {
            [self.delegate selectedGraphWithData:[dataArr objectAtIndex:indexPath.row]];
        }
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

#pragma mark - JPPackagePictureGraphCellDelegate

- (void)deletePictureAtIndex:(int)index {
    [dataArr removeObjectAtIndex:index];
    [collecView reloadData];
}

#pragma mark - notifications

- (void)addPicture:(NSNotification *)notification {
    NSArray *arr = [notification object];
    if (arr && [arr count]) {
        [dataArr addObjectsFromArray:arr];
    }
    [collecView reloadData];
}

@end
