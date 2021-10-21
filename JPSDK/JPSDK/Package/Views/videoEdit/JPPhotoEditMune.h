//
//  JPPhotoEditMune.h
//  jper
//
//  Created by FoundaoTEST on 2017/7/26.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPPhotoEditMuneDelegate <NSObject>

- (void)photoEditMuneWillEditVideoPhotoAnimationTypeWithModel:(JPVideoModel *)videoModel withReduceAction:(BOOL)reduce;
- (void)photoEditMuneWillDelegateThisVideo:(JPVideoModel *)videoModel;


@end

@interface JPPhotoEditMune : UIView
@property (nonatomic, weak) id<JPPhotoEditMuneDelegate> delegate;
@property (nonatomic, weak) JPVideoModel *videoModel;

@end
