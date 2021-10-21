//
//  JPPackageMenuAttributeView.h
//  jper
//
//  Created by 藩 亜玲 on 2017/3/29.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPPatternInteractiveView.h"
#import "JPPackageMenuBaseView.h"
@protocol JPPackagePatternAttributeViewDelegate <NSObject>
- (void)patternAttributeViewWillHide;
@end

@interface JPPackagePatternAttributeView : JPPackageMenuBaseView

@property (nonatomic, weak) id<JPPackagePatternAttributeViewDelegate>delegate;

- (void)updateViewWithType:(JPPackagePatternAttribute *)attribute andVideoCompositon:(JPVideoCompositionPlayer *)compositonPlayer;
@property (nonatomic, strong) JPPatternInteractiveView *apearView;
- (void)dismiss;
@property (nonatomic, strong, readonly) JPPackagePatternAttribute *patternAttributeModel;
@property (nonatomic, strong) UIView *timeView;
@end
