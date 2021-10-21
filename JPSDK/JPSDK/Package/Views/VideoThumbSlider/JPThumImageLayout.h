//
//  JPThumImageLayout.h
//  jper
//
//  Created by FoundaoTEST on 2017/8/2.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UICollectionViewDelegateTimelineLayout <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didAdjustToWidth:(CGFloat)width forItemAtIndexPath:(NSIndexPath *)indexPath andChangedStartOffset:(CGFloat)offset;
- (CGFloat)collectionView:(UICollectionView *)collectionView widthForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface JPThumImageLayout : UICollectionViewLayout
@property (nonatomic) UIEdgeInsets trackInsets;
@property (nonatomic) CGFloat trackHeight;

- (void)adjustedToWidth:(CGFloat)width;
@end
