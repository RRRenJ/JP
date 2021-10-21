//
//  JPPackageMenuAttributeTimeSliderCell.h
//  jper
//
//  Created by 藩 亜玲 on 2017/5/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPPatternInteractiveView.h"

@protocol JPPackageMenuAttributeTimeSliderCellDelelgate <NSObject>

- (void)rangeSliderValueDidChangeWithLeftValue:(CGFloat)left andRightValue:(CGFloat)right;
- (void)rangeSliderValueDidEndChangeWithLeftValue:(CGFloat)left andRightValue:(CGFloat)right;

@end

@interface JPPackageMenuAttributeTimeSliderCell : UICollectionViewCell

@property (nonatomic, strong) JPPatternInteractiveView *patternInteractiveView;
@property (nonatomic, weak) id<JPPackageMenuAttributeTimeSliderCellDelelgate>delegate;
@property (nonatomic, strong) UIView *pointView;
- (void)updateSliderWithMinValue:(CGFloat)min
                     andMaxValue:(CGFloat)max
                    andLeftValue:(CGFloat)left
                   andRightVlaue:(CGFloat)right;

@end
