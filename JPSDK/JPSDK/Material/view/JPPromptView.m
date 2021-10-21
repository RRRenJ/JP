//
//  JPPromptView.m
//  jper
//
//  Created by FoundaoTEST on 2017/6/9.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPromptView.h"

@interface JPPromptView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGRect reallyRect;
@property (nonatomic) NSTextAlignment alignment;
@property (nonatomic) BOOL isTop;

@end

@implementation JPPromptView

- (instancetype)initWithView:(UIView *)view andType:(JPPromptViewType)type andSuperView:(UIView *)superView andTopOffset:(CGFloat)topOffset andLeftOffset:(CGFloat)leftOffset
{
    NSString *imageName = [NSString stringWithFormat:@"0%zd",type];
    if (type == JPPromptViewTypeTenth || type == JPPromptViewTypeEleventh || type == JPPromptViewTypetwlve || type == JPPromptViewTypethirteen) {
        imageName = [NSString stringWithFormat:@"%zd",type];
    }
    UIImage *image = JPImageWithName(imageName);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView sizeToFit];
    CGSize size = imageView.size;
    NSTextAlignment alignment = NSTextAlignmentLeft;
    CGRect frame = [view convertRect:view.bounds toView:superView];
    if (frame.origin.x + frame.size.width / 2.0 + size.width / 2.0 > superView.width - 5) {
        frame.origin.x = frame.origin.x + frame.size.width - size.width;
        alignment = NSTextAlignmentRight;
    }else if (frame.origin.x + frame.size.width / 2.0 - size.width / 2.0 > 5)
    {
        frame.origin.x = frame.origin.x + frame.size.width / 2.0 - size.width / 2.0;
        alignment = NSTextAlignmentCenter;
    }
    frame.origin.x = frame.origin.x + leftOffset;
    BOOL isTop = NO;
    if (frame.origin.y < size.height + topOffset) {
        frame.origin.y = frame.origin.y + frame.size.height + topOffset;
        
    }else{
        frame.origin.y = frame.origin.y - size.height - topOffset;
        isTop = YES;
    }
    if (type == JPPromptViewTypeTenth) {
        frame.origin.x = 15;
        alignment = NSTextAlignmentLeft;
    }
    frame.size = size;
    if (self = [self initWithFrame:frame]) {
        _reallyRect = frame;
        _alignment = alignment;
        _isTop = isTop;
        self.backgroundColor = [UIColor clearColor];
        _imageView = imageView;
        self.clipsToBounds = YES;
        [superView addSubview:self];
        self.hidden = YES;
        [self addSubview:_imageView];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf dismiss];
        });
    }
    return self;
}

- (void)show
{
    CGFloat originY = _reallyRect.origin.y;
    if (_isTop == YES) {
        originY = _reallyRect.origin.y + _reallyRect.size.height - 1;
    }
    if (_alignment == NSTextAlignmentLeft) {
        self.frame = CGRectMake(_reallyRect.origin.x, originY, 1, 1);
    }else if (_alignment == NSTextAlignmentCenter)
    {
        self.frame = CGRectMake(_reallyRect.origin.x + _reallyRect.size.width / 2.0, originY, 1, 1);
    }else{
        self.frame = CGRectMake(_reallyRect.origin.x + _reallyRect.size.width, originY, 1, 1);
    }
    _imageView.frame = CGRectMake(0, 0, 1, 1);
    self.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = self.reallyRect;
        self.imageView.frame = CGRectMake(0, 0, self.reallyRect.size.width, self.reallyRect.size.height);
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat originY = self.reallyRect.origin.y;
        if (self.isTop == YES) {
            originY = self.reallyRect.origin.y + self.reallyRect.size.height - 1;
        }
        if (self.alignment == NSTextAlignmentLeft) {
            self.frame = CGRectMake(self.reallyRect.origin.x, originY, 1, 1);
        }else if (self.alignment == NSTextAlignmentCenter)
        {
            self.frame = CGRectMake(self.reallyRect.origin.x + self.reallyRect.size.width / 2.0, originY, 1, 1);
        }else{
            self.frame = CGRectMake(self.reallyRect.origin.x + self.reallyRect.size.width, originY, 1, 1);
        }
        self.imageView.frame = CGRectMake(0, 0, 1, 1);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

@end
