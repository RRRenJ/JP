//
//  JPNewFilterCollectionViewCell.h
//  jper
//
//  Created by FoundaoTEST on 2017/6/1.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JPNewFilterCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isPage;
@property (nonatomic, strong) JPFilterModel *selectFilterModel;
- (void)updateFilterSelectModel:(JPFilterModel *)model andIsSelect:(BOOL)isSelect;
@end
