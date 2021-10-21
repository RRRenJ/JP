//
//  JPBackgroundMusicCell.h
//  jper
//
//  Created by 藩 亜玲 on 2017/4/17.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPBackgroundMusicCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *txtLb;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, assign) BOOL isSelect;

- (void)changeMSelectedState;
- (void)setCellNeedsLayout;

@end
