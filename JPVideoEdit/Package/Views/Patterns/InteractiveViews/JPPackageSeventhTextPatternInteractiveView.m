//
//  JPPackageSeventhTextPatternInteractiveView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/6/9.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageSeventhTextPatternInteractiveView.h"
#import "JPPackageSeventhTextPattern.h"

@interface JPPackageSeventhTextPatternInteractiveView() {
    JPPackageSeventhTextPattern *textPatternView;
}

@end

@implementation JPPackageSeventhTextPatternInteractiveView

- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute{
    [super setPatternAttribute:patternAttribute];
    if (textPatternView == nil) {
        textPatternView = [[JPPackageSeventhTextPattern alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        self.contentView = textPatternView;
    }
    textPatternView.patternAttribute = patternAttribute;
}

@end
