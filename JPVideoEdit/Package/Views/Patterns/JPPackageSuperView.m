//
//  JPPackageSuperView.m
//  jper
//
//  Created by FoundaoTEST on 2017/4/18.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageSuperView.h"

@implementation JPPackageSuperView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
}

- (CGSize)getMyReallySizeWithPackagePatternAttribute:(JPPackagePatternAttribute *)patternAttribute andScale:(CGFloat)scale
{
    return CGSizeZero;
}
@end
