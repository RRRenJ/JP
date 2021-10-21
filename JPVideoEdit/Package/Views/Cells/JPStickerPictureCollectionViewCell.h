//
//  JPStickerPictureCollectionViewCell.h
//  jper
//
//  Created by FoundaoTEST on 2017/6/6.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPStickerPictureCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewWidthLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHeightLayoutConstraint;
@end
