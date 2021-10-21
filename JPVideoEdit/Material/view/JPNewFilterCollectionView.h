//
//  JPNewFilterCollectionView.h
//  jper
//
//  Created by FoundaoTEST on 2017/6/1.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPNewFilterCollectionViewDelegate <NSObject>

- (void)newFilterCollectionViewDidSelectFilter:(JPFilterModel *)filterModel;

- (void)collectionScrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface JPNewFilterCollectionView : UIView
@property (nonatomic, weak) id<JPNewFilterCollectionViewDelegate>delegate;
@property (nonatomic, readonly, strong) JPFilterModel *currentFilterModel;
@property (nonatomic, assign) BOOL isPage;

- (void)reloadRecordInfo:(JPVideoRecordInfo *)recordInfo;

- (UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath;


@end
