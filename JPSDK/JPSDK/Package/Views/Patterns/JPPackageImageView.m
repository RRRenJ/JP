//
//  JPPackageImageView.m
//  jper
//
//  Created by FoundaoTEST on 2017/4/18.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageImageView.h"

@interface JPPackageImageView ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation JPPackageImageView

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
    _imageView.image = patternAttribute.originImage;
}


- (CGSize)getMyReallySizeWithPackagePatternAttribute:(JPPackagePatternAttribute *)patternAttribute andScale:(CGFloat)scale
{
    CGSize size;
    if (patternAttribute.patternType != JPPackagePatternTypeWeekPicture && patternAttribute.patternType != JPPackagePatternTypeDownloadedPicture) {
        CGSize imageSize = self.patternAttribute.thumPicture.size;
        CGSize reallySize = CGSizeMake(50,( 50 / imageSize.width) * imageSize.height);
        size = reallySize;
        
    }else{
        size = CGSizeMake(patternAttribute.frame.size.width - 26, patternAttribute.frame.size.height - 26);
    }
    return size;
}
@end
