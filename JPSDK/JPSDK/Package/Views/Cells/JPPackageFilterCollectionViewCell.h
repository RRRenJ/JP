//
//  JPPackageFilterCollectionViewCell.h
//  jper
//
//  Created by 藩 亜玲 on 2017/6/3.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPPackageFilterCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) JPFilterModel *selectFilterModel;

- (void)updateFilterModel:(JPFilterModel *)filterModel andIsSelect:(BOOL)isSelect;

@end
