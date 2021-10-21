//
//  JPPackageHollowOutView.m
//  jper
//
//  Created by FoundaoTEST on 2017/6/6.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageHollowOutView.h"

@interface JPPackageHollowOutView ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation JPPackageHollowOutView

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
    NSString *title = @"4to3";
    if (patternAttribute.videoFrame == JPVideoAspectRatio16X9) {
        title = @"16to9";
    }else if (patternAttribute.videoFrame == JPVideoAspectRatio9X16)
    {
        title = @"9to16";

    }else if (patternAttribute.videoFrame == JPVideoAspectRatio1X1 || patternAttribute.videoFrame == JPVideoAspectRatioCircular)
    {
        title = @"1to1";
    }
    _imageView.image = patternAttribute.originImage;
}

- (CGSize)getMyReallySizeWithPackagePatternAttribute:(JPPackagePatternAttribute *)patternAttribute andScale:(CGFloat)scale
{
    return CGSizeMake(patternAttribute.frame.size.width * scale - 26, patternAttribute.frame.size.height * scale - 26);
}

@end
