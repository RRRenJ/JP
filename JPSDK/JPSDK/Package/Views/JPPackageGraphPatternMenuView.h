//
//  JPJPPackageGraphPatternMenuView.h
//  jper
//
//  Created by 藩 亜玲 on 2017/4/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPPackageMenuBaseView.h"
@protocol JPPackageGraphPatternMenuViewDelegate <NSObject>

- (void)toPicturePickerView;

- (void)selectedGraphWithData:(JPPackagePatternAttribute *)data;

- (void)hide;
- (void)deleteGraphWithData:(JPPackagePatternAttribute *)data;

@end

@interface JPPackageGraphPatternMenuView : JPPackageMenuBaseView

@property (nonatomic, weak) id<JPPackageGraphPatternMenuViewDelegate>delegate;
@property (nonatomic, weak) JPVideoRecordInfo *recordInfo;
@property (nonatomic, assign) CMTime currentTime;
@property (nonatomic, strong) JPPackagePatternAttribute *selectHotPatternAttribute;

- (void)show;
@end
