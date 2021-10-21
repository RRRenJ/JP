//
//  JPLogoSelectCollectionViewCell.h
//  jper
//
//  Created by FoundaoTEST on 2017/4/18.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPLogoSelectCollectionViewCell : UICollectionViewCell
@property (nonatomic, assign) BOOL isAddPicture;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) JPPackagePatternAttribute * patternAttribute;

- (void)changeMSelectedState;

- (void)setCellNeedsLayout;

@end
