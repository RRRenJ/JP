//
//  JPPackageTextAndBackgroudView.m
//  jper
//
//  Created by FoundaoTEST on 2017/4/18.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageTextAndBackgroudView.h"
#import "JPPackageTextBackgroudColorView.h"


@interface JPPackageTextAndBackgroudView () {
    JPPackageTextBackgroudColorView *textPatternView;
}
@end

@implementation JPPackageTextAndBackgroudView

- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute
{
    [super setPatternAttribute:patternAttribute];
    if (textPatternView == nil) {
        textPatternView = [[JPPackageTextBackgroudColorView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        self.contentView = textPatternView;
    }
    textPatternView.patternAttribute = patternAttribute;
}

//- (void)updateContent
//{
//    textPatternView.patternAttribute = self.patternAttribute;
//    CGFloat width = [UIFont widthForText:self.patternAttribute.text andFontSize:[UIFont fontWithName:self.patternAttribute.textFontName size:self.patternAttribute.textFontSize] andHeight:20] + 10;
//    self.frame = CGRectMake(self.patternAttribute.frame.origin.x, self.patternAttribute.frame.origin.y, width + 26, 35 + 26);
//    self.patternAttribute.frame = self.frame;
//    [super updateContent];
//}
@end

