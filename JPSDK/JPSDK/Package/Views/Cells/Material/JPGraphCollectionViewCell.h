//
//  JPGraphCollectionViewCell.h
//  jper
//
//  Created by 藩 亜玲 on 2017/7/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPMaterial.h"

@protocol JPGraphCollectionViewCellDelegate <NSObject>

- (void)toDownloadTheMdoel:(JPMaterial *)material andIndex:(NSInteger)index;
@end


@interface JPGraphCollectionViewCell : UICollectionViewCell
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) id<JPGraphCollectionViewCellDelegate>delegate;

- (void)loadDataWithResource:(JPMaterial *)info;

- (void)updateViewWithProgress:(double)progress;

- (void)hiddenProgressView;

- (void)showProgressView;

@end
