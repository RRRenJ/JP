//
//  JPSelectVideosViewCell.h
//  jper
//
//  Created by FoundaoTEST on 2017/6/2.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPSelectVideosViewCellDelegate <NSObject>

- (void)selectVideosViewCellShouldDeleteVideoModel:(JPVideoModel *)videoModel;

@end

@interface JPSelectVideosViewCell : UICollectionViewCell

@property (nonatomic, weak) id<JPSelectVideosViewCellDelegate>delegate;
@property (nonatomic, weak) JPVideoModel *videoModel;
@property (nonatomic, assign) NSInteger videoIndex;
@end
