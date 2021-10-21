//
//  JPNewClidView.m
//  jper
//
//  Created by FoundaoTEST on 2017/7/28.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPNewClidView.h"

@interface JPNewClidView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@property (nonatomic, assign) CGFloat startPoint;
@property (nonatomic, assign) CGFloat totalWidth;
@property (nonatomic, assign) CMTime currentTotleTime;
@property (nonatomic, assign) CGFloat maxWidth;

@end
@implementation JPNewClidView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self createSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    self.backgroundColor = [UIColor clearColor];
    [JPResourceBundle loadNibNamed:@"JPNewClidView" owner:self options:nil];
    [self addSubview:self.view];
    self.view.sd_layout.topEqualToView(self).rightEqualToView(self).bottomEqualToView(self).leftEqualToView(self);
    [JPUtil setViewRadius:self.leftImageView byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(3, 3)];
    [JPUtil setViewRadius:self.rightImageView byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(3, 3)];
    UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftPanAction:)];
    leftPan.minimumNumberOfTouches = 1;
    leftPan.maximumNumberOfTouches = 5;
    UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightPanAction:)];
    rightPan.minimumNumberOfTouches = 1;
    rightPan.maximumNumberOfTouches = 5;
    [_leftView addGestureRecognizer:leftPan];
    [_rightView addGestureRecognizer:rightPan];
    self.totalTimeLabel.layer.shadowOpacity = 0.1;
    self.totalTimeLabel.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.totalTimeLabel.layer.shadowRadius = 1;
    self.totalTimeLabel.layer.shadowColor = [UIColor blackColor].CGColor;
}

- (void)leftPanAction:(UIPanGestureRecognizer *)pan
{
    if (pan.state != UIGestureRecognizerStateBegan && pan.state != UIGestureRecognizerStateChanged) {
        if (self.delegate) {
            [self.delegate endUpdateWithInfoModel:_thumbInfoModel];
        }
        return;
    }
    if (pan.state == UIGestureRecognizerStateBegan) {
        _currentTotleTime = CMTimeSubtract(_recordInfo.currentTotalTime, _thumbInfoModel.videoDuration);
        _maxWidth = ceilf(CMTimeGetSeconds(CMTimeSubtract(_recordInfo.totalDuration, _currentTotleTime)) * 60);
    }
    CGPoint point = [pan translationInView:self.leftImageView];
    CGFloat start = self.startPoint;
    CGFloat end = start + self.width;
    start = start + point.x;
    if (start <= 0) {
        start = 0;
    }
    if (end - start < 120) {
        start = end - 120;
        _leftImageView.image = JPImageWithName(@"left-y");
        _rightImageView.image = JPImageWithName(@"right-y");

    }else if(end - start > _maxWidth){
        start = end - _maxWidth;
        _leftImageView.image = JPImageWithName(@"left-y");
        _rightImageView.image = JPImageWithName(@"right-y");
    }else{
        _leftImageView.image = JPImageWithName(@"left_slide");
        _rightImageView.image = JPImageWithName(@"right_slide");
    }
    CGFloat width = end - start;
    _startPoint = start;
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeStartPoint:andWidth:)]) {
        [self.delegate changeStartPoint:start andWidth:width];
    }
    [pan setTranslation:CGPointMake(0, 0) inView:self.leftImageView];
}


- (void)setWidth:(CGFloat)width
{
    [super setWidth:width];
    _leftImageView.image = JPImageWithName(@"left_slide");
    _rightImageView.image = JPImageWithName(@"right_slide");
}

- (void)rightPanAction:(UIPanGestureRecognizer *)pan
{
    if (pan.state != UIGestureRecognizerStateBegan && pan.state != UIGestureRecognizerStateChanged) {
        if (self.delegate) {
            [self.delegate endUpdateWithInfoModel:_thumbInfoModel];
        }
        return;
    }
    if (pan.state == UIGestureRecognizerStateBegan) {
        _currentTotleTime = CMTimeSubtract(_recordInfo.currentTotalTime, _thumbInfoModel.videoDuration);
        _maxWidth = ceilf(CMTimeGetSeconds(CMTimeSubtract(_recordInfo.totalDuration, _currentTotleTime)) * 60);
    }
    CGPoint point = [pan translationInView:self.rightImageView];
    CGFloat start = self.startPoint;
    CGFloat end = start + self.width;
    end = end + point.x;
    if (end >= _totalWidth) {
        end = _totalWidth;
    }
    if (end - start < 120) {
        end = start + 120;
        _leftImageView.image = JPImageWithName(@"left-y");
        _rightImageView.image = JPImageWithName(@"right-y");
        
    }else if(end - start > _maxWidth)
    {
        end = start + _maxWidth;
        _leftImageView.image = JPImageWithName(@"left-y");
        _rightImageView.image = JPImageWithName(@"right-y");
    }else{
        _leftImageView.image = JPImageWithName(@"left_slide");
        _rightImageView.image = JPImageWithName(@"right_slide");
    }
    CGFloat width = end - start;
    _startPoint = start;
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeEndPoint:)]) {
        [self.delegate changeEndPoint:width];
    }
    [pan setTranslation:CGPointMake(0, 0) inView:self.rightImageView];

}

- (void)setThumbInfoModel:(JPThumbInfoModel *)thumbInfoModel
{
    _thumbInfoModel = thumbInfoModel;
    _startPoint = thumbInfoModel.startPoint;
    Float64 duration = CMTimeGetSeconds(_thumbInfoModel.totalDuration);
    NSInteger reallyPixel = (NSInteger)floor(duration * 30) * 2;
    _totalWidth =  reallyPixel;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.hidden == YES) {
        return nil;
    }
    if (CGRectContainsPoint(_leftView.frame, point)) {
        return _leftView;
    }else if (CGRectContainsPoint(_rightView.frame, point))
    {
        return _rightView;

    }
    
    return nil;
}

@end
