//
//  JPPackageFilterMenuView.h
//  jper
//
//  Created by 藩 亜玲 on 2017/6/3.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageMenuBaseView.h"
#import "JPNewFilterCollectionView.h"

@protocol JPPackageFilterMenuViewDelegate <NSObject>

- (void)packageFilterMenuViewDidSelectFilter:(JPFilterModel *)filterModel;
- (void)packageFilterMenuViewWillDismiss;
- (void)collectionScrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface JPPackageFilterMenuView : JPPackageMenuBaseView

@property (nonatomic, strong, readonly) JPNewFilterCollectionView * collecView;

@property (nonatomic, weak) id<JPPackageFilterMenuViewDelegate>delegate;
- (void)reloadRecordInfo:(JPVideoRecordInfo *)recordInfo;
@end
