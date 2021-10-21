//
//  JPVideoInfoTableViewCell.h
//  jper
//
//  Created by FoundaoTEST on 2017/4/1.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JPVideoInfoTableViewCell;
@protocol JPVideoInfoTableViewCellDelagete <NSObject>

- (void)videoInfoTableViewCellShouldAddVideo:(JPVideoInfoTableViewCell *)cell;
- (void)videoInfoTableViewCellShouldDeleteVideo:(JPVideoInfoTableViewCell *)cell;
- (void)videoInfoTableViewCellShouldEditVideo:(JPVideoInfoTableViewCell *)cell;
- (void)videoInfoTableViewCellSelect:(JPVideoInfoTableViewCell *)cell andPan:(UIPanGestureRecognizer *)pan;
- (void)videoInfoTableViewCellSelectLocationChange:(JPVideoInfoTableViewCell *)cell andPan:(UIPanGestureRecognizer *)pan;
- (void)videoInfoTableViewCellSelectLocationEnd:(JPVideoInfoTableViewCell *)cell andPan:(UIPanGestureRecognizer *)pan;

@end
@interface JPVideoInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) JPVideoModel *model;
@property (nonatomic, strong, readonly) UILabel *videoNumbersLabel;
@property (nonatomic, weak) id<JPVideoInfoTableViewCellDelagete> delegate;
@property (nonatomic, strong) UIView *editView;
@property (nonatomic, strong) UIView *deleteView;

- (void)setAddButton;
- (void)hiddenStatusImageView;;

@end
