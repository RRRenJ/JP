//
//  JPGifContentView.m
//  jper
//
//  Created by FoundaoTEST on 2017/11/14.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPGifContentView.h"


@interface JPGifContentView ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation JPGifContentView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_imageView];
        self.backgroundColor = [UIColor clearColor];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.sd_layout.topEqualToView(self).bottomEqualToView(self).leftEqualToView(self).rightEqualToView(self);
        _imageView.clipsToBounds= YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute
{
    [super setPatternAttribute:patternAttribute];
//    [_imageView stopAnimating];
    _imageView.image = [patternAttribute getlastImage];
//    _imageView.animationDuration = ((CGFloat)patternAttribute.gifPNGCount) / 30.0;     //执行一次完整动画所需的时长
//    _imageView.animationRepeatCount = 0;  //动画重复次数
//    [_imageView startAnimating];
}


- (CGSize)getMyReallySizeWithPackagePatternAttribute:(JPPackagePatternAttribute *)patternAttribute andScale:(CGFloat)scale
{
     return patternAttribute.gifImageSize;
}


- (void)dismiss
{
//    if (_imageView.isAnimating) {
//        [_imageView stopAnimating];
//    }
}

- (void)show
{
//    if (!_imageView.isAnimating) {
//        [_imageView startAnimating];
//    }
}
@end
