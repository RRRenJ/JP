//
//  JPHorizontalCollectionViewLayout.m
//  jper
//
//  Created by 藩 亜玲 on 2017/3/29.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPHorizontalCollectionViewLayout.h"

@implementation JPHorizontalCollectionViewLayout{
    NSInteger _cellCount;
    CGSize _boundsSize;
    CGFloat _maxWidth;
    NSInteger _curentPage;
    NSMutableDictionary *_attributesFrameDic;
    NSMutableArray *_attributesArr;
}

- (void)prepareLayout{
    // Get the number of cells and the bounds size
    _cellCount = [self.collectionView numberOfItemsInSection:0];
    _boundsSize = self.collectionView.bounds.size;
    _attributesFrameDic = [NSMutableDictionary dictionary];
}

- (CGSize)collectionViewContentSize{
    // We should return the content size. Lets do some math:
    CGSize size = _boundsSize;
    size.width = ceilf(_maxWidth / _boundsSize.width) * _boundsSize.width;
    return size;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    // This method requires to return the attributes of those cells that intsersect with the given rect.
    // In this implementation we just return all the attributes.
    // In a better implementation we could compute only those attributes that intersect with the given rect.
    
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:_cellCount];
    
    for (NSUInteger i=0; i<_cellCount; ++i){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [self _layoutForAttributesForCellAtIndexPath:indexPath];
        
        [allAttributes addObject:attr];
    }
    _attributesArr = allAttributes;
    if (self.pageChangeDelegate && [self.pageChangeDelegate respondsToSelector:@selector(horizontalCollectionViewLayout:currentPage:)]) {
        _curentPage = ceil(floor(_maxWidth) / _boundsSize.width);
        [self.pageChangeDelegate horizontalCollectionViewLayout:self currentPage:_curentPage];
    }
    return allAttributes;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return _attributesArr[indexPath.row];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    // We should do some math here, but we are lazy.
    return YES;
}

- (UICollectionViewLayoutAttributes*)_layoutForAttributesForCellAtIndexPath:(NSIndexPath*)indexPath{
    // Here we have the magic of the layout.
    
    
    CGRect bounds = self.collectionView.bounds;
    CGSize itemSize = _itemSize;
    if (self.layoutDelegate && [self.layoutDelegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        itemSize = [self.layoutDelegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
//    // Get some info:
//    NSInteger verticalItemsCount = (NSInteger)floorf(bounds.size.height / itemSize.height);
//    NSInteger horizontalItemsCount = (NSInteger)floorf(bounds.size.width / itemSize.width);
//    NSInteger itemsPerPage = verticalItemsCount * horizontalItemsCount;
//    
//    // Compute the column & row position, as well as the page of the cell.
//    NSInteger columnPosition = row%horizontalItemsCount;
//    NSInteger rowPosition = (row/horizontalItemsCount)%verticalItemsCount;
//    NSInteger itemPage = floorf(row/itemsPerPage);
    CGRect lastFrame = CGRectZero;
    if (indexPath.row > 0) {
        NSString *key = [NSString stringWithFormat:@"%d", indexPath.row - 1];
        NSValue *value = _attributesFrameDic[key];
        lastFrame = value.CGRectValue;
    }
    // Creating an empty attribute
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect frame = CGRectZero;
    
    // And finally, we assign the positions of the cells
    frame.origin.x = lastFrame.size.width + lastFrame.origin.x ;
    frame.origin.y = lastFrame.origin.y;
    frame.size = itemSize;
    if (indexPath.row != 0) {
        NSInteger curentPage = ((NSInteger)lastFrame.origin.x) / ((NSInteger)bounds.size.width);
        CGFloat right = (NSInteger)floor(frame.size.width + frame.origin.x);
        if ((right / (NSInteger)bounds.size.width) > curentPage && (right) > (curentPage + 1) * bounds.size.width) {
            frame.origin.x = curentPage * bounds.size.width;
            frame.origin.y = lastFrame.origin.y + lastFrame.size.height;
        }
        
        if (frame.origin.y + frame.size.height > bounds.size.height && frame.origin.y != 0) {
            frame.origin.x = (curentPage + 1) * bounds.size.width;
            frame.origin.y = 0;
        }
    }
    NSString *key = [NSString stringWithFormat:@"%d", indexPath.row];
    [_attributesFrameDic setObject:[NSValue valueWithCGRect:frame] forKey:key];

    attr.frame = frame;
    _maxWidth = _maxWidth < attr.frame.origin.x + attr.frame.size.width ?  attr.frame.origin.x + attr.frame.size.width : _maxWidth;
    return attr;
}

#pragma mark Properties

- (void)setItemSize:(CGSize)itemSize{
    _itemSize = itemSize;
    [self invalidateLayout];
}

@end
