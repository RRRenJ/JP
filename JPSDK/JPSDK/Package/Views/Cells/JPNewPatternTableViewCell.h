//
//  JPNewPatternTableViewCell.h
//  jper
//
//  Created by FoundaoTEST on 2017/8/1.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPPatternInteractiveView.h"

@protocol JPNewPatternTableViewCellDelegate <NSObject>

- (void)rangeSliderValueDidChangeWithLeftValue:(CGFloat)left andRightValue:(CGFloat)right andAttrubute:(JPPackagePatternAttribute *)patternAttribute;
- (void)rangeSliderValueDidEndChangeWithLeftValue:(CGFloat)left andRightValue:(CGFloat)right andAttrubute:(JPPackagePatternAttribute *)patternAttribute;
@end

@interface JPNewPatternTableViewCell : UITableViewCell
@property (nonatomic, strong) JPPackagePatternAttribute *atturbue;
@property (nonatomic, weak) id<JPNewPatternTableViewCellDelegate>delegate;
@property (nonatomic, strong) UIView *pointView;
- (void)updateSliderWithMinValue:(CGFloat)min
                     andMaxValue:(CGFloat)max
                    andLeftValue:(CGFloat)left
                   andRightVlaue:(CGFloat)right;
@end
