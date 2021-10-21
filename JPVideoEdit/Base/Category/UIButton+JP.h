//
//  UIButton+JP.h
//  JPSDK
//
//  Created by 任敬 on 2021/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JPButtonEdgeInsetsStyle) {
    JPButtonEdgeInsetsStyleTop, // image在上，label在下
    JPButtonEdgeInsetsStyleLeft, // image在左，label在右
    JPButtonEdgeInsetsStyleBottom, // image在下，label在上
    JPButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (JP)

- (void)jp_layoutButtonWithEdgeInsetsStyle:(JPButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
