//
//  JPGifListCellCollectionViewCell.h
//  jper
//
//  Created by FoundaoTEST on 2017/11/14.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPGifListCellCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) JPPackagePatternAttribute *patternAttribute;
- (void)stopAnimation;
- (void)startAnimation;
@end
