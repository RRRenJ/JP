//
//  JPPromptView.h
//  jper
//
//  Created by FoundaoTEST on 2017/6/9.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JPPromptViewType)
{
    JPPromptViewTypeFirst = 1,
    JPPromptViewTypeSecond,
    JPPromptViewTypeThird,
    JPPromptViewTypeFourth,
    JPPromptViewTypeFifth,
    JPPromptViewTypeSixth,
    JPPromptViewTypeSeventh,
    JPPromptViewTypeEighth,
    JPPromptViewTypeNinth,
    JPPromptViewTypeTenth,
    JPPromptViewTypeEleventh,
    JPPromptViewTypetwlve,
    JPPromptViewTypethirteen,
};

@interface JPPromptView : UIView

- (instancetype)initWithView:(UIView *)view andType:(JPPromptViewType)type andSuperView:(UIView *)superView andTopOffset:(CGFloat)topOffset andLeftOffset:(CGFloat)leftOffset;
- (void)show;
- (void)dismiss;
@end
