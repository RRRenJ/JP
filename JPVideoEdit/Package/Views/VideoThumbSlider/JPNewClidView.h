//
//  JPNewClidView.h
//  jper
//
//  Created by FoundaoTEST on 2017/7/28.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPThumbInfoModel.h"

@protocol JPNewClidViewDelegate <NSObject>

- (void)changeStartPoint:(CGFloat)startPoint andWidth:(CGFloat)width;
- (void)changeEndPoint:(CGFloat)endPoint;
- (void)endUpdateWithInfoModel:(JPThumbInfoModel *)infoModel;
@end

@interface JPNewClidView : UIView

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (nonatomic, strong) JPThumbInfoModel *thumbInfoModel;
@property (nonatomic, weak) id<JPNewClidViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (nonatomic, weak) JPVideoRecordInfo *recordInfo;
@end
