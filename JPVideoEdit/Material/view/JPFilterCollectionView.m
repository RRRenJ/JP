//
//  JPFilterCollectionView.m
//  jper
//
//  Created by FoundaoTEST on 2017/3/24.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPFilterCollectionView.h"
#import "JPFiltersCollectionViewCell.h"
#import "JPFilterManagers.h"

static NSString *JPFiltersCellIdentifier = @"JPFiltersCellIdentifier";

@interface JPFilterCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (nonatomic, strong) NSArray<JPFilterModel *> *dataSource;
@property (nonatomic, assign) JPFilterModel *selelctFilterModel;
@end

@implementation JPFilterCollectionView

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

- (void)createSubviews
{
    [JPResourceBundle loadNibNamed:@"JPFilterCollectionView" owner:self options:nil];
    [self addSubview:self.view];
    self.view.sd_layout.topEqualToView(self);
    self.view.sd_layout.rightEqualToView(self);
    self.view.sd_layout.bottomEqualToView(self);
    self.view.sd_layout.leftEqualToView(self);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"JPFiltersCollectionViewCell" bundle:JPResourceBundle] forCellWithReuseIdentifier:JPFiltersCellIdentifier];
    _dataSource = [JPFilterManagers getFiltersArr];
    _selelctFilterModel = _dataSource.firstObject;
}

#pragma mark UICollectionViewDataSource UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JPFiltersCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JPFiltersCellIdentifier forIndexPath:indexPath];
    JPFilterModel *filterModel = _dataSource[indexPath.row];
    [cell updateFilterModel:filterModel andIsSelect:[filterModel isEqual:_selelctFilterModel]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    JPFilterModel *model = _dataSource[indexPath.row];
    _selelctFilterModel = model;
    [_collectionView reloadData];
    if (_delegate) {
        [_delegate changeTheSelectfilter:model];
    }
}


- (JPFilterModel *)currentSelectModel
{
    return _selelctFilterModel;
}



- (void)reloadSelectFilterModel:(JPFilterModel *)filterModel
{
    _selelctFilterModel = filterModel;
    if (_selelctFilterModel == nil) {
        _selelctFilterModel = _dataSource.firstObject;
    }
    [self.collectionView reloadData];
}

@end
