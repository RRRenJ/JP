//
//  JPTextWithBorderInteractiveView.m
//  jper
//
//  Created by FoundaoTEST on 2017/4/25.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPTextWithBorderInteractiveView.h"
#import "JPPackageTextWithBorderPatternView.h"
@interface JPTextWithBorderInteractiveView () {
    JPPackageTextWithBorderPatternView *textPatternView;
}
@end

@implementation JPTextWithBorderInteractiveView

- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute
{
    [super setPatternAttribute:patternAttribute];
    if (textPatternView == nil) {
        textPatternView = [[JPPackageTextWithBorderPatternView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) withGraphType:patternAttribute];
        self.contentView = textPatternView;
    }
    textPatternView.patternAttribute = patternAttribute;
}

//- (void)updateContent
//{
//    textPatternView.patternAttribute = self.patternAttribute;
//    if (self.patternAttribute.patternType == JPPackagePatternTypeTextWithUpAndDownLine) {
//        CGFloat width = [UIFont widthForText:self.patternAttribute.text andFontSize:[UIFont fontWithName:self.patternAttribute.textFontName size:self.patternAttribute.textFontSize] andHeight:20] + 50;
//        self.frame = CGRectMake(self.patternAttribute.frame.origin.x, self.patternAttribute.frame.origin.y, width + 26, 50 + 26);
//        self.patternAttribute.frame = self.frame;
// 
//    }else if (self.patternAttribute.patternType == JPPackagePatternTypeTextWithBorderLine)
//    {
//        CGFloat width = [UIFont widthForText:self.patternAttribute.text andFontSize:[UIFont fontWithName:self.patternAttribute.textFontName size:self.patternAttribute.textFontSize] andHeight:20] + 46;
//        if (width < 70) {
//            width = 70;
//        }
//        self.frame = CGRectMake(self.patternAttribute.frame.origin.x, self.patternAttribute.frame.origin.y, width + 26, 70 + 26);
//        self.patternAttribute.frame = self.frame;
//    }
//     [super updateContent];
//}

@end
