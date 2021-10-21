//
//  JPVideoRecordProgressView.h
//  jper
//
//  Created by FoundaoTEST on 2017/3/28.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JPVideoRecordProgressView : UIView

@property (nonatomic, strong) JPVideoRecordInfo *recordInfo;
- (void)becomeAddViewWithVideoSourceType:(JPVideoSourceType)sourceType;
- (void)updateViewWidthWithDuration:(CMTime)duration;
- (void)endUpdateViewWithVideoModel:(JPVideoModel *)videoModel;
- (void)changeProgress:(CGFloat)progress;
@end
