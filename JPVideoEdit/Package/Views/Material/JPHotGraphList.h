//
//  JPHotGraphList.h
//  jper
//
//  Created by Monster_lai on 2017/7/27.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPHotGraphListDelegate <NSObject>

- (void)selectedHotGraphWithData:(JPPackagePatternAttribute *)data;
- (void)deleteHotGraphWithData:(JPPackagePatternAttribute *)data;

@end

@interface JPHotGraphList : UIView

@property (nonatomic, assign) id<JPHotGraphListDelegate> delegate;
@property (nonatomic, assign) CMTime currentTime;
@property (nonatomic, weak) JPVideoRecordInfo *recordInfo;
@property (nonatomic, strong) JPPackagePatternAttribute *selectHotAttribute;
@end
