//
//  JPThumImageLayout.m
//  jper
//
//  Created by FoundaoTEST on 2017/8/2.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPThumImageLayout.h"

@interface JPThumImageLayout ()
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, strong) NSDictionary *calculatedLayout;

@end

@implementation JPThumImageLayout

- (void)prepareLayout {
    
    NSMutableDictionary *layoutDictionary = [NSMutableDictionary dictionary];
    
    CGFloat maxTrackWidth = 0.0f;
    
    id <UICollectionViewDelegateTimelineLayout> delegate = (id <UICollectionViewDelegateTimelineLayout>) self.collectionView.delegate;
    
    NSUInteger trackCount = [self.collectionView numberOfSections];
    for (NSInteger track = 0; track < trackCount; track++) {
        CGFloat xPos = self.trackInsets.left;
        CGFloat yPos = 0;

        for (NSInteger item = 0, itemCount = [self.collectionView numberOfItemsInSection:track]; item < itemCount; item++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:track];
            
            UICollectionViewLayoutAttributes *attributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            CGFloat width = [delegate collectionView:self.collectionView widthForItemAtIndexPath:indexPath];
            attributes.frame = CGRectMake(xPos, yPos + self.trackInsets.top, width, self.trackHeight - self.trackInsets.bottom);
            xPos += width;
            layoutDictionary[indexPath] = attributes;
            if (xPos >= maxTrackWidth) {
                maxTrackWidth = xPos;
            }
        }
        
    }
    maxTrackWidth += self.trackInsets.right;
    self.contentSize = CGSizeMake(maxTrackWidth, trackCount * self.trackHeight);
    
    self.calculatedLayout = layoutDictionary;
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *allAttributesInRect = [NSMutableArray arrayWithCapacity:self.calculatedLayout.count];
    
    for (NSIndexPath *indexPath in self.calculatedLayout) {
        UICollectionViewLayoutAttributes *attributes = self.calculatedLayout[indexPath];
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributesInRect addObject:attributes];
        }
    }
    
    return allAttributesInRect;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.calculatedLayout[indexPath];
}

- (void)adjustedToWidth:(CGFloat)width {
      [self invalidateLayout];
}
@end
