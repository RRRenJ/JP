//
//  JPNextButton.m
//  jper
//
//  Created by FoundaoTEST on 2017/6/10.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPNextButton.h"

@interface JPNextButton ()

@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UIView *backView;

@end

@implementation JPNextButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _backView.backgroundColor = [UIColor jp_colorWithHexString:@"0091FF"];
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius  = 10;
    _backView.userInteractionEnabled = NO;
    [self addSubview:_backView];
    _backView.sd_layout.centerXEqualToView(self).centerYEqualToView(self).widthIs(20).heightIs(20);
    _titleImageView = [[UIImageView alloc] initWithImage:JPImageWithName(@"next")];
    [_titleImageView sizeToFit];
    [self addSubview:_titleImageView];
    _titleImageView.sd_layout.centerYEqualToView(self).leftSpaceToView(_backView, -20 + (_backView.width - _titleImageView.width) / 2 + 1).widthIs(_titleImageView.width).heightIs(_titleImageView.height);
    
}


- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    if (self.userInteractionEnabled == userInteractionEnabled) {
        return;
    }
    [super setUserInteractionEnabled:userInteractionEnabled];
    [self animationWithDismiss:!userInteractionEnabled];
}


- (void)setHidden:(BOOL)hidden
{
//    [super setHidden:hidden];
    if (self.hidden == hidden) {
        return;
    }
    [_backView.layer removeAllAnimations];
    [_titleImageView.layer removeAllAnimations];
    [super setUserInteractionEnabled:NO];
    if (hidden) {
        [UIView animateWithDuration:0.1 animations:^{
            self.backView.alpha = 0;
        } completion:^(BOOL finished) {
            self.backView.transform = CGAffineTransformMakeScale(0.5, 0.5);
            [super setUserInteractionEnabled:YES];
            [super setHidden:hidden];
        }];
    }else{
        [super setHidden:hidden];
        [UIView animateWithDuration:0.2 animations:^{
            self.backView.alpha = 1.0;
            self.backView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    self.backView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                } completion:^(BOOL finished) {
                    [super setUserInteractionEnabled:YES];
                    [super setHidden:hidden];
                }];
            }else{
                [super setUserInteractionEnabled:YES];
                [super setHidden:hidden];

            }
        }];
        
    }
}


- (void)animationWithDismiss:(BOOL)dismiss
{
    [_backView.layer removeAllAnimations];
    [_titleImageView.layer removeAllAnimations];
    if (dismiss) {
        [UIView animateWithDuration:0.1 animations:^{
            self.backView.alpha = 0;
        } completion:^(BOOL finished) {
            self.backView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.backView.alpha = 1.0;
            self.backView.transform = CGAffineTransformMakeScale(1.1, 1.1);

        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    self.backView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }];
            }
        }];

    }
}



@end
