//
//  JPLocalFileCollectionViewCell.h
//  jper
//
//  Created by FoundaoTEST on 2017/3/24.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPLocalFileModel.h"

@protocol JPLocalFileCollectionViewCellDelegate <NSObject>

- (void)deleteTheItemWithIndex:(NSInteger)index;

@end

@interface JPLocalFileCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) JPLocalFileModel *fileModel;
@property (nonatomic, assign) BOOL isAddVideo;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) id<JPLocalFileCollectionViewCellDelegate>delegate;

- (void)loadSourceWith:(JPLocalFileModel *)model;

@end
