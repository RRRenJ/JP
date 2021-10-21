//
//  JPSelectVideosView.m
//  jper
//
//  Created by FoundaoTEST on 2017/6/2.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPSelectVideosView.h"
#import "JPSelectVideosViewCell.h"
@interface JPSelectVideosView ()<UICollectionViewDataSource, JPSelectVideosViewCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *view;

@end

@implementation JPSelectVideosView

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
    [JPResourceBundle loadNibNamed:@"JPSelectVideosView" owner:self options:nil];
    [self addSubview:self.view];
    self.view.sd_layout.topEqualToView(self).bottomEqualToView(self).rightEqualToView(self).leftEqualToView(self);
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"JPSelectVideosViewCell" bundle:JPResourceBundle] forCellWithReuseIdentifier:@"JPSelectVideosViewCell"];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}

- (void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    [_collectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JPSelectVideosViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPSelectVideosViewCell" forIndexPath:indexPath];
    cell.videoIndex = indexPath.row + 1;
    cell.videoModel = _dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}


- (void)selectVideosViewCellShouldDeleteVideoModel:(JPVideoModel *)videoModel
{
    if (self.delegate) {
        [self.delegate selectVideosViewShouldDeleteVideoModel:videoModel];
    }
}
@end
