//
//  JPGradualLineView.h
//  jper
//
//  Created by 藩 亜玲 on 2017/8/24.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPGadualLineViewDelegate <NSObject>

- (void)animationDidStart;
- (void)animationDidStop;

@end

@interface JPGradualLineView : UIView
@property (nonatomic, weak) id<JPGadualLineViewDelegate>delegate;

- (void)startAnimation;
- (instancetype)initWithFrame:(CGRect )frame andIsActive:(BOOL)iaActive;

@end
