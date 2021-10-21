//
//  JPMaterialTypeCollectionCell.h
//  jper
//
//  Created by 藩 亜玲 on 2017/7/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPMaterialTypeCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, copy) NSString * title;

@property (nonatomic, assign) BOOL isCustom;

@end
