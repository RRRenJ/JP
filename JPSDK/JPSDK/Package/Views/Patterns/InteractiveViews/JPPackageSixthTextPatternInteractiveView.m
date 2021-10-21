//
//  JPPackageSixthTextPatternInteractiveView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/6/9.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageSixthTextPatternInteractiveView.h"
#import "JPPackageSixthTextPattern.h"

@interface JPPackageSixthTextPatternInteractiveView() {
    JPPackageSixthTextPattern *textPatternView;
}

@end

@implementation JPPackageSixthTextPatternInteractiveView

- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute{
    [super setPatternAttribute:patternAttribute];
    if (textPatternView == nil) {
        textPatternView = [[JPPackageSixthTextPattern alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        self.contentView = textPatternView;
    }
    textPatternView.patternAttribute = patternAttribute;
}


@end
