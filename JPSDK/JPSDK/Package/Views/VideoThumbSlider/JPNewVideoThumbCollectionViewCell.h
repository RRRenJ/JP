//
//  JPNewVideoThumbCollectionViewCell.h
//  jper
//
//  Created by FoundaoTEST on 2017/7/25.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPThumbInfoModel.h"

@protocol JPNewVideoThumbCollectionViewCellDelegate <NSObject>

- (void)changeVideoTranstionTypeWithInfoModel:(JPThumbInfoModel *)infoModel;
- (void)changeVideoTranstionTypeAddVideo;
- (void)changeVideoTranstionTypeDisInfoModel:(JPThumbInfoModel *)infoModel;

@end

@interface JPNewVideoThumbCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) id<JPNewVideoThumbCollectionViewCellDelegate>delegate;
@property (nonatomic, strong) JPThumbInfoModel *infoModel;
@property (nonatomic, assign) BOOL isLast;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, weak) UIButton *buttonView;
@property (nonatomic, strong) UIImageView * addIV;
@property (nonatomic, weak) UIView *backgroundClibView;
- (void)setTranstionModelSelect:(BOOL)select;
@end
