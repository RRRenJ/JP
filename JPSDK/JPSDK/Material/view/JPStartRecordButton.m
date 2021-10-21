//
//  JPStartRecordButton.m
//  jper
//
//  Created by FoundaoTEST on 2017/6/1.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPStartRecordButton.h"

@interface JPStartRecordButton ()

@property (nonatomic, strong) UIView *layerView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *secondsLabel;
@property (nonatomic, assign) BOOL labelButtonScal;
@property (nonatomic, assign) BOOL textBecomeChange;
@property (nonatomic, assign) BOOL textStart;
@property (nonatomic, assign) BOOL layerBecomeChange;
@property (nonatomic, assign) BOOL becomeHidden;

@end

@implementation JPStartRecordButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self createSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}
- (void)createSubviews{
    
    self.backgroundColor = [UIColor clearColor];
    _layerView = [[UIView alloc] initWithFrame:self.bounds];
    _layerView.backgroundColor = [UIColor clearColor];
    _layerView.layer.masksToBounds = YES;
    _layerView.layer.cornerRadius = 37.5;
    _layerView.layer.borderWidth = 2;
    _layerView.layer.borderColor = [UIColor whiteColor].CGColor;
    _layerView.userInteractionEnabled = NO;
    [self addSubview:_layerView];
    _backView = [[UIView alloc] initWithFrame:CGRectMake(_layerView.left + 5,_layerView.top + 5, 65, 65)];
    _backView.backgroundColor = [UIColor jp_colorWithHexString:@"0091FF"];
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 32.5;
    _backView.userInteractionEnabled = NO;
    [self addSubview:_backView];
    _secondsLabel = [[UILabel alloc] initWithFrame:CGRectMake(_backView.left,_backView.top , 65, 65)];
    _secondsLabel.backgroundColor = [UIColor clearColor];
    _secondsLabel.layer.masksToBounds = YES;
    _secondsLabel.layer.cornerRadius = 32.5;
    _secondsLabel.textColor = [UIColor whiteColor];
    _secondsLabel.textAlignment = NSTextAlignmentCenter;
    _secondsLabel.font = [UIFont fontWithName:@"PlacardMTStd-Cond" size:34];
    _secondsLabel.alpha = 0.0;
    [self addSubview:_secondsLabel];

}

- (void)updateProgressWithTime:(CMTime)time
{
    if (_textBecomeChange == YES && _textStart == NO) {
        _textStart = YES;
    }
    if (_textBecomeChange == YES && _textStart == YES) {
        if (_layerBecomeChange == NO) {
            _layerBecomeChange = YES;
            [self backViewAnimationViewWithScale:NO];
        }
        CMTime duraion = time;
        double seconds = CMTimeGetSeconds(duraion);
        _secondsLabel.text = [NSString stringWithFormat:@"%.1f", seconds];
    }
    if (!_labelButtonScal) {
        _labelButtonScal = YES;
        [UIView animateWithDuration:0.1 animations:^{
            self.backView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.backView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
            } completion:^(BOOL finished) {
                self.textBecomeChange = YES;
                [UIView animateWithDuration:0.1 animations:^{
                    self.secondsLabel.alpha = 1.0;
                    self.backView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    
                    
                }];
                
            }];
            
        }];
    }

}

- (void)backViewAnimationViewWithScale:(BOOL)scale
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1.0 animations:^{
        if (scale == NO) {
            weakSelf.layerView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        }else{
            weakSelf.layerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf backViewAnimationViewWithScale:!scale];
        }
    }];
}

- (void)endRecord
{
    [_secondsLabel.layer removeAllAnimations];
    [_backView.layer removeAllAnimations];
    [_layerView.layer removeAllAnimations];
    _textStart = NO;
    _layerBecomeChange = NO;
    _becomeHidden = NO;
    _labelButtonScal = NO;
    _textBecomeChange = NO;
    _backView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    _backView.backgroundColor = [UIColor jp_colorWithHexString:@"0091FF"];
    _layerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    _backView.alpha = 1.0;
    _secondsLabel.alpha = 0.0;
}
@end
