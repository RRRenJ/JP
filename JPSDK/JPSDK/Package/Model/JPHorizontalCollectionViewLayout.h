//
//  JPHorizontalCollectionViewLayout.h
//  jper
//
//  Created by 藩 亜玲 on 2017/3/29.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JPHorizontalCollectionViewLayout;

@protocol JPHorizontalCollectionViewLayoutDelegate <NSObject>

- (void)horizontalCollectionViewLayout:(JPHorizontalCollectionViewLayout *)layout currentPage:(NSInteger)currentPage;

@end

@interface JPHorizontalCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, weak) id<UICollectionViewDelegateFlowLayout> layoutDelegate;
@property (nonatomic, weak) id<JPHorizontalCollectionViewLayoutDelegate> pageChangeDelegate;

@end
