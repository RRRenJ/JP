//
//  JFRecordTitleView.h
//  jper
//
//  Created by FoundaoTEST on 2017/3/21.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JFRecordTitleViewDelegate <NSObject>

- (void)recordTitleViewNeedShowStep;

@end

@interface JFRecordTitleView : UIView
@property (nonatomic) JPVideoEditStep step;
@property (nonatomic, weak) id<JFRecordTitleViewDelegate>delegate;
@end
