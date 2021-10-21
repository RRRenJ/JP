//
//  UIColor+JP.h
//  JPSDK
//
//  Created by 任敬 on 2021/9/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (JP)

+ (UIColor *)jp_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor *)jp_colorWithHexString:(NSString *)color;

@end

NS_ASSUME_NONNULL_END
