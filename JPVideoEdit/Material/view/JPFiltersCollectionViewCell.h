//
//  JPFiltersCollectionViewCell.h
//  jper
//
//  Created by FoundaoTEST on 2017/3/21.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPFiltersCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) JPFilterModel * curerntfilterModel;
- (void)updateFilterModel:(JPFilterModel *)filterModel andIsSelect:(BOOL)isSelect;
@end
