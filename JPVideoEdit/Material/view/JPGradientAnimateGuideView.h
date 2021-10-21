//
//  JPGradientAnimateGuideView.h
//  jper
//
//  Created by 藩 亜玲 on 2017/8/24.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPGradientAnimateGuideView : UIView

- (id)initWithFrame:(CGRect)frame andText:(NSString *)str;
- (void)startAnimation;
- (id)initWithFrame:(CGRect)frame andText:(NSString *)str andIsActive:(BOOL)isActive;

@end
