//
//  JPActiveMessageView.m
//  jper
//
//  Created by FoundaoTEST on 2017/11/17.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPActiveMessageView.h"

@implementation JPActiveMessageView
- (instancetype)initActive
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"active_daoxu_tishi" ofType:@"png"];
    if (self = [super initWithImage:[UIImage imageWithContentsOfFile:path]]) {
        self.frame = CGRectMake((JP_SCREEN_WIDTH - 219) / 2.0, (JP_SCREEN_HEIGHT - 192) / 2.0, 219, 192);
        self.alpha = 0.0;
    }
    return self;
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.10 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.alpha = 1.0;
        self.transform = CGAffineTransformMakeScale(0.7, 0.7);
        [UIView animateWithDuration:0.15 animations:^{
            self.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
            }];
            
        }];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.05 animations:^{
        
        self.transform = CGAffineTransformMakeScale(1.1, 1.1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.transform = CGAffineTransformMakeScale(0.7, 0.7);
        } completion:^(BOOL finished) {
            self.alpha = 0.0;
            [UIView animateWithDuration:0.1 animations:^{
                self.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }];
    }];
}
@end
