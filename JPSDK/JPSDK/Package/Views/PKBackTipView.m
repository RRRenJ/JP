//
//  PKBackTipView.m
//  jper
//
//  Created by 赖星果 on 2019/12/6.
//  Copyright © 2019 MuXiao. All rights reserved.
//

#import "PKBackTipView.h"

@interface PKBackTipView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIButton *notSaveBtn;

@end

@implementation PKBackTipView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self configueView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configueView];
    }
    return self;
}

- (void)configueView{
    [JPResourceBundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
    self.view.sd_layout.bottomEqualToView(self).topEqualToView(self).leftEqualToView(self).rightEqualToView(self);
    [self configueSubview];
    [self layoutSubviews];
}


- (void)configueSubview {
    self.bgView.layer.cornerRadius = 7.0f;
    self.saveBtn.layer.cornerRadius = 15.0f;
    self.notSaveBtn.layer.cornerRadius = 15.0f;
    self.notSaveBtn.layer.masksToBounds = YES;
    self.notSaveBtn.layer.borderColor = [UIColor jp_colorWithHexString:@"0091FF"].CGColor;
    self.notSaveBtn.layer.borderWidth = 1.0f;
}

- (IBAction)saveAndBackAction:(id)sender {
    [self.layer removeAllAnimations];
    [self.contentView.layer removeAllAnimations];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
        self.contentView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        self.alpha = 0.0;
        [self removeFromSuperview];
        if (self.dismissCompletion) {
            self.dismissCompletion(YES);
        }
    }];
}

- (IBAction)notSaveBackAction:(id)sender {
    [self.layer removeAllAnimations];
    [self.contentView.layer removeAllAnimations];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
        self.contentView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        self.alpha = 0.0;
        [self removeFromSuperview];
        if (self.dismissCompletion) {
            self.dismissCompletion(NO);
        }
    }];
}

- (IBAction)cancelAction:(id)sender {
    [self.layer removeAllAnimations];
    [self.contentView.layer removeAllAnimations];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
        self.contentView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        self.alpha = 0.0;
        [self removeFromSuperview];
    }];
}

- (void)showInView:(UIView *)view
{
    if (self.superview) {
        [self removeFromSuperview];
    }
    [view addSubview:self];
    [self.layer removeAllAnimations];
    [self.contentView.layer removeAllAnimations];
    self.alpha = 0.0;
    self.hidden = NO;
    self.userInteractionEnabled = NO;
    self.contentView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIView * view = touches.anyObject.view;
    if ([view isEqual:self.view] ) {
        [self.layer removeAllAnimations];
        [self.contentView.layer removeAllAnimations];
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0.0;
            self.contentView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            self.hidden = YES;
            self.userInteractionEnabled = NO;
            self.alpha = 0.0;
            [self removeFromSuperview];
        }];
    }
}

@end
