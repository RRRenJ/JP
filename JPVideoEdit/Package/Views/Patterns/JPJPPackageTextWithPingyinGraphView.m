//
//  JPJPPackageTextWithPingyinGraphView.m
//  jper
//
//  Created by FoundaoTEST on 2017/4/14.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPJPPackageTextWithPingyinGraphView.h"
#import "JPPackageTextPatternView.h"

@interface JPJPPackageTextWithPingyinGraphView () {
    JPPackageTextPatternView *textPatternView;
}

@end
@implementation JPJPPackageTextWithPingyinGraphView

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
