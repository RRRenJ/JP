//
//  JPTextFontCell.h
//  jper
//
//  Created by 藩 亜玲 on 2017/6/5.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPFontModel.h"

@interface JPTextFontCell : UICollectionViewCell

@property (nonatomic, strong) JPFontModel *model;
@property (nonatomic, assign) BOOL isSelect;

- (void)changeMSelectedState;
- (void)setCellNeedsLayout;

@end
