//
//  JPRecordInfoView.h
//  jper
//
//  Created by FoundaoTEST on 2017/5/15.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JPRecordInfoView.h"

@class JPRecordInfoView;
@protocol JPRecordInfoViewDelegate <NSObject>

- (void)recordInfoViewNeedSelect:(JPRecordInfoView *)infoView;
- (void)recordInfoViewNeddDeselect:(JPRecordInfoView *)infoView;
@end
@interface JPRecordInfoView : UIView
@property (nonatomic, assign) BOOL isSelect;
- (instancetype)initWithAudioModel:(JPAudioModel *)audioModel andMaxLength:(CGFloat)w andRecordInfo:(JPVideoRecordInfo *)info;
@property (nonatomic, strong) JPAudioModel *audioModel;
@property (nonatomic, weak) id<JPRecordInfoViewDelegate>delegate;
- (void)updateFrameWithMaxLength:(CGFloat)w andRecordInfo:(JPVideoRecordInfo *)info;
@end
