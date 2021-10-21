//
//  JPPackageFilterMenuView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/6/3.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageFilterMenuView.h"


@interface JPPackageFilterMenuView ()<JPNewFilterCollectionViewDelegate>{
    JPNewFilterCollectionView *_collectionView;
}

@property (nonatomic, strong) NSArray *filterArr;
@property (nonatomic, strong) JPVideoRecordInfo *recordInfo;

@property (nonatomic, strong) JPNewFilterCollectionView * collecView;

@end

@implementation JPPackageFilterMenuView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTittle:@"滤镜添加"];
        _collectionView = [[JPNewFilterCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, 90)];
        [self addSubview:_collectionView];
        _collectionView.delegate = self;
        _collectionView.isPage = YES;
        _collectionView.sd_layout.centerYEqualToView(self).centerXEqualToView(self).widthRatioToView(self, 1.0).heightIs(90);
        self.collecView = _collectionView;
    }
    return self;
}

- (void)dismiss {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(packageFilterMenuViewWillDismiss)]) {
        [self.delegate packageFilterMenuViewWillDismiss];
    }
}

- (void)collectionScrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(collectionScrollViewDidScroll:)]) {
        [self.delegate collectionScrollViewDidScroll:scrollView];
    }
}

- (void)newFilterCollectionViewDidSelectFilter:(JPFilterModel *)filterModel
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(packageFilterMenuViewDidSelectFilter:)]) {
        [self.delegate packageFilterMenuViewDidSelectFilter:filterModel];
    }
}

- (void)reloadRecordInfo:(JPVideoRecordInfo *)recordInfo
{
    _recordInfo = recordInfo;
    [_collectionView reloadRecordInfo:recordInfo];
}
@end
