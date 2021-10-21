//
//  JPHotGraphListCollectionViewCell.h
//  jper
//
//  Created by Monster_lai on 2017/7/27.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "JPHotlistGraphModel.h"

@protocol  JPHotGraphListCollectionViewCellDelegate <NSObject>

- (void)selectedGraphWithData:(JPPackagePatternAttribute *)data;

@end

@interface JPHotGraphListCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) JPPackagePatternAttribute *model;

@property (nonatomic, assign) BOOL isSelect;

- (void)changeMSelectedState;
- (void)setCellNeedsLayout;

@end
