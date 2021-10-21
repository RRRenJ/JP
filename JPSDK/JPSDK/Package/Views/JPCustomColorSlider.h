//
//  JPCustomColorSlider.h
//  jper
//
//  Created by 藩 亜玲 on 2017/3/30.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPCustomColorSlider : UIView

- (id)initWithFrame:(CGRect)frame withColors:(NSArray *)colorArr;
- (void)setColorIndex:(NSInteger)index;
@property (nonatomic, copy) void(^valueChangeBlock)(NSInteger colorIndex, UIColor *color);
@end
