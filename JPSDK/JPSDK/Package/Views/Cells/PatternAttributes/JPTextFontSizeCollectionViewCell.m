//
//  JPTextFontCollectionViewCell.m
//  jper
//
//  Created by FoundaoTEST on 2017/5/26.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPTextFontSizeCollectionViewCell.h"

@interface JPTextFontSizeCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *smallButton;
@property (weak, nonatomic) IBOutlet UIButton *normalButton;

@property (weak, nonatomic) IBOutlet UIButton *bigButton;
@property (weak, nonatomic) IBOutlet UIView *sliderView;
@property (weak, nonatomic) IBOutlet UIView *thumbView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderViewOriginX;
@property (weak, nonatomic) IBOutlet UIView *sliderBackView;

@end

@implementation JPTextFontSizeCollectionViewCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    _thumbView.layer.masksToBounds = YES;
    _thumbView.layer.borderWidth = 1;
    _thumbView.layer.borderColor = [UIColor whiteColor].CGColor;
    _thumbView.layer.cornerRadius = 10;
    _thumbView.backgroundColor = [UIColor jp_colorWithHexString:@"0e0e0e"];
    UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightPanAction:)];
    rightPan.minimumNumberOfTouches = 1;
    rightPan.maximumNumberOfTouches = 5;
    [_sliderView addGestureRecognizer:rightPan];

}

- (void)rightPanAction:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan translationInView:self.sliderView];
        CGFloat consant = _sliderViewOriginX.constant + point.x;
        if (consant < 40) {
            consant = 40;
        }
        if (consant > 40 + _sliderBackView.width) {
            consant = 40 + _sliderBackView.width;
        }
        [self updateFontWithConstant:consant - 40];
    }
    [pan setTranslation:CGPointMake(0, 0) inView:self.sliderView];
}

- (void)updateFontWithConstant:(CGFloat)constant
{
    _sliderViewOriginX.constant = constant + 40;
    CGFloat radio = constant / _sliderBackView.width;
    NSInteger font = 65 * radio + 10;
    _patternInteractiveView.patternAttribute.textFontSize = font;
    [_patternInteractiveView updateContent];
    _thumbView.transform = CGAffineTransformMakeScale(radio * 0.5 + 0.5, radio * 0.5 + 0.5);
}

- (IBAction)changeFontSize:(id)sender {
    [self.smallButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bigButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.normalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIButton *button = (UIButton *)sender;
    [button setTitleColor:[UIColor jp_colorWithHexString:@"0091ff"] forState:UIControlStateNormal];
//    if (sender == self.normalButton) {
//        _patternInteractiveView.patternAttribute.textFontType = JPTextFontNormal;
//    }else if(sender == self.bigButton){
//        _patternInteractiveView.patternAttribute.textFontType = JPTextFontBig;
//    }else{
//        _patternInteractiveView.patternAttribute.textFontType = JPTextFontSmall;
//    }
    [_patternInteractiveView updateContent];
}

- (void)setPatternInteractiveView:(JPPatternInteractiveView *)patternInteractiveView
{
    [self layoutIfNeeded];
    _patternInteractiveView = patternInteractiveView;
    CGFloat constant = (((CGFloat)(patternInteractiveView.patternAttribute.textFontSize - 10)) / 65.0f) * _sliderBackView.width;
    [self updateFontWithConstant:constant];
}

@end
