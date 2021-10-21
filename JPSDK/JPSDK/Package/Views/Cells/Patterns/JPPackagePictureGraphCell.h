//
//  JPPackagePictureGraphCell.h
//  jper
//
//  Created by 藩 亜玲 on 2017/4/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPPackagePictureGraphCellDelegate <NSObject>

- (void)deletePictureAtIndex:(int)index;

@end

@interface JPPackagePictureGraphCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) BOOL showDeleteBtn;
@property (nonatomic, weak) id<JPPackagePictureGraphCellDelegate>delegate;

@end
