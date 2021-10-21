//
//  JPNewFilterCollectionView.m
//  jper
//
//  Created by FoundaoTEST on 2017/6/1.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPNewFilterCollectionView.h"
#import "JPNewFilterCollectionViewCell.h"
#import "JPFilterManagers.h"
@interface JPNewFilterCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *filterArr;
@property (nonatomic, strong) JPFilterModel *selectFilterModel;
@property (nonatomic, strong) JPVideoRecordInfo *recordInfo;

@end

@implementation JPNewFilterCollectionView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self createSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}


- (void)createSubviews{
    _filterArr = [JPFilterManagers getFiltersArr];
    self.selectFilterModel = _filterArr.firstObject;
    self.backgroundColor = [UIColor clearColor];
    [JPResourceBundle loadNibNamed:@"JPNewFilterCollectionView" owner:self options:nil];
    [self addSubview:self.view];
    self.view.sd_layout.topEqualToView(self).bottomEqualToView(self).rightEqualToView(self).leftEqualToView(self);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"JPNewFilterCollectionViewCell" bundle:JPResourceBundle] forCellWithReuseIdentifier:@"JPNewFilterCollectionViewCell"];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.clipsToBounds = NO;
}


- (void)setIsPage:(BOOL)isPage
{
    _isPage = isPage;
    if (isPage == YES) {
        _collectionLayout.itemSize = CGSizeMake(60, 90);
        _collectionLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _collectionLayout.minimumLineSpacing = 15;
        _collectionLayout.minimumInteritemSpacing = 15;
        self.backgroundColor = [UIColor clearColor];
    }else{
        _collectionLayout.itemSize = CGSizeMake(60, 90);
        _collectionLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionLayout.minimumLineSpacing = 0;
        _collectionLayout.minimumInteritemSpacing = 0;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
    [_collectionView reloadData];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(collectionScrollViewDidScroll:)] && scrollView == _collectionView) {
        [self.delegate collectionScrollViewDidScroll:_collectionView];
    }
}

- (UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.collectionView cellForItemAtIndexPath:indexPath];
}

#pragma mark -- UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _filterArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JPNewFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPNewFilterCollectionViewCell" forIndexPath:indexPath];
    cell.isPage = _isPage;
    JPFilterModel *filterModel = _filterArr[indexPath.row];
    [cell updateFilterSelectModel:filterModel andIsSelect:[filterModel isEqual:self.selectFilterModel]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JPFilterModel *selectfilterModel = [_filterArr objectAtIndex:indexPath.row];
    self.selectFilterModel = selectfilterModel;
    [_collectionView reloadData];
    if (self.delegate) {
        [self.delegate newFilterCollectionViewDidSelectFilter:selectfilterModel];
    }
}

- (void)reloadRecordInfo:(JPVideoRecordInfo *)recordInfo
{
    _recordInfo = recordInfo;
    _selectFilterModel = recordInfo.currentFilterModel;
    if (_selectFilterModel == nil) {
        _selectFilterModel = _filterArr.firstObject;
    }
    [_collectionView reloadData];
    if (recordInfo.aspectRatio != JPVideoAspectRatio9X16 && _isPage == NO) {
        self.backgroundColor = [UIColor blackColor];
    }else if (_isPage == NO)
    {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
}

- (JPFilterModel *)currentFilterModel
{
    return _selectFilterModel;
}
@end
