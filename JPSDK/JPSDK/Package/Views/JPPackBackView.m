//
//  JPPackBackView.m
//  jper
//
//  Created by FoundaoTEST on 2017/6/21.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackBackView.h"

@implementation JPPackBackView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    for (UIView *view in self.subviews) {
        if (view.hidden == NO && CGRectContainsPoint(view.frame, point)) {
            return YES;
        }
    }
    if (CGRectContainsPoint(self.bounds, point)) {
        return YES;
    }else{
        return NO;
    }
}

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    UIView *button = [self viewWithTag:100000];
    if (button != nil) {
        [self bringSubviewToFront:button];
    }
}

@end
