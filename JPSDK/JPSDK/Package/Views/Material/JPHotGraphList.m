//
//  JPHotGraphList.m
//  jper
//
//  Created by Monster_lai on 2017/7/27.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPHotGraphList.h"
#import "JPHotGraphListCollectionViewCell.h"
#import "JPHotlistGraphModel.h"

@interface JPHotGraphList ()<UICollectionViewDelegate, UICollectionViewDataSource> {
    
    UICollectionView *_collectionView;
    JPPackagePatternAttribute * selectedAttr;
}

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation JPHotGraphList

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.dataArr = [self getAllWeekPicture];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向为垂直流布局
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(JPScreenFitFloat6(100), JPScreenFitFloat6(135));
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0 , self.width,self.height - 10) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.backgroundColor = self.backgroundColor;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[JPHotGraphListCollectionViewCell class] forCellWithReuseIdentifier:@"JPHotGraphListCollectionViewCell"];
        [self addSubview:_collectionView];
        
        _collectionView.sd_layout.centerYEqualToView(self).leftEqualToView(self).rightEqualToView(self).heightIs(JPScreenFitFloat6(135));
    }
    return self;
}

- (NSArray *)getAllWeekPicture
{
    //NSArray *arr = @[@"无封面", @"杂志封面", @"DVD封面", @"INTERFACE", @"拍立得", @"拾光相片", @"Record MAG",@"JPER MAG",@"时间画报",@"LIVE STORY",@"MEMORIES",@"N.07 GAME",@"记忆画报",@"时间标签",@"玖月",@"STARS",@"DREAM DAY"];
    NSArray *arr = @[@"无封面", @"杂志封面", @"拾光相片", @"Record MAG",@"时间画报",@"LIVE STORY",@"MEMORIES",@"记忆画报",@"时间标签",@"玖月",@"STARS",@"DREAM DAY"];
    NSMutableArray *array = [NSMutableArray array];
    JPPackagePatternAttribute *attribute = [[JPPackagePatternAttribute alloc] init];
    attribute.text = arr[0];
    attribute.patternType = JPPackagePatternTypeWeekPicture;
    selectedAttr = attribute;
    [array addObject:attribute];
    for (NSInteger index = 1; index <= 11; index ++) {
        @autoreleasepool {    
            JPPackagePatternAttribute * attribute = [[JPPackagePatternAttribute alloc] init];
            NSString *numberStr;
            if (index + 3 < 10) {
                numberStr = [NSString stringWithFormat:@"P0%zd", index + 3];
            } else {
                numberStr = [NSString stringWithFormat:@"P%zd", index + 3];
            }
            attribute.thumImageIfFromBundle = YES;
            attribute.thumPictureName = [NSString stringWithFormat:@"H%zd", index];
            attribute.originImageName = numberStr;
            attribute.text = arr[index];
            CGSize size = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:numberStr ofType:@".png"]].size;
            attribute.originImgSize = CGSizeMake(size.width/2.0, size.height/2.0);
            attribute.patternName = numberStr;
            attribute.patternType = JPPackagePatternTypeWeekPicture;
            attribute.frame = CGRectMake(50, 50, 150 + 26, (150 / attribute.thumPicture.size.width * attribute.thumPicture.size.height) + 26);
            [array addObject:attribute];
        }
    }
    return array;
}

- (void)setSelectHotAttribute:(JPPackagePatternAttribute *)selectHotAttribute
{
    _selectHotAttribute = selectHotAttribute;
    selectedAttr = selectHotAttribute;
    [_collectionView reloadData];
}

#pragma mark -- UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JPPackagePatternAttribute *model = _dataArr[indexPath.row];
    JPHotGraphListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPHotGraphListCollectionViewCell" forIndexPath:indexPath];
    cell.model = model;
    if (0 == indexPath.row) {
        if (!selectedAttr) {
            cell.isSelect = YES;
        } else {
            cell.isSelect = NO;
        }
    }else {
        if ([selectedAttr.originImageName isEqualToString:model.originImageName]) {
            cell.isSelect = YES;
        } else {
            cell.isSelect = NO;
        }
    }
    
    [cell setCellNeedsLayout];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JPPackagePatternAttribute *model = _dataArr[indexPath.row];
    if (0 == indexPath.row) {
        if (!selectedAttr) {
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteHotGraphWithData:)]) {
            [self.delegate deleteHotGraphWithData:selectedAttr];
        }
        selectedAttr = nil;
    }else {
        if ([selectedAttr.originImageName isEqualToString:model.originImageName]) {
            return;
        }
        if (selectedAttr) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteHotGraphWithData:)]) {
                [self.delegate deleteHotGraphWithData:selectedAttr];
            }
        }
        selectedAttr = model;
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectedHotGraphWithData:)]) {
            [self.delegate selectedHotGraphWithData:selectedAttr];
        }
    }
    [collectionView reloadData];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, JPScreenFitFloat6(15), 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return JPScreenFitFloat6(15);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

@end
