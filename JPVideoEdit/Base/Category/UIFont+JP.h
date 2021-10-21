//
//  UIFont+JP.h
//  JPSDK
//
//  Created by 任敬 on 2021/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (JP)

+ (UIFont *)titleFont;

+ (UIFont *)EnglishTitleFont;

+ (UIFont *)contentFont;

+ (UIFont *)EnglishContentFont;

+ (UIFont *)jp_pingFangWithSize:(CGFloat)size;

+ (UIFont *)jp_pingFangWithSize:(CGFloat)size weight:(UIFontWeight)weight;

+ (UIFont *)jp_placardMTStdCondBoldFontWithSize:(CGFloat)size;

+ (CGFloat)jp_widthForText:(NSString *)text andFontSize:(UIFont *)font andHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
