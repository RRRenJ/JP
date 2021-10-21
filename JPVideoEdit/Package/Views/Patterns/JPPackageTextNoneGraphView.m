//
//  JPPackageTextNoneGraphView.m
//  jper
//
//  Created by FoundaoTEST on 2017/4/14.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageTextNoneGraphView.h"
#import "JPPackageTextPatternView.h"


@interface JPPackageTextNoneGraphView () {
    JPPackageTextPatternView *textPatternView;
}

@end
@implementation JPPackageTextNoneGraphView



- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute
{
    [super setPatternAttribute:patternAttribute];
    if (textPatternView == nil) {
        textPatternView = [[JPPackageTextPatternView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) withGraphType:patternAttribute];
        self.contentView = textPatternView;
    }
    textPatternView.patternAttribute = patternAttribute;
}

@end
