//
//  JPTextWithUpBorderInteractiveView.m
//  jper
//
//  Created by FoundaoTEST on 2017/4/25.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPTextWithUpBorderInteractiveView.h"

#import "JPPackageTextWithBorderPatternView.h"
@interface JPTextWithUpBorderInteractiveView () {
    JPPackageTextWithBorderPatternView *textPatternView;
}
@end

@implementation JPTextWithUpBorderInteractiveView

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
//    textPatternView.attribute = self.patternAttribute;
//    if (self.patternAttribute.patternType == JPPackagePatternTypeTextWithUpAndDownLine) {
//        CGFloat width = [UIFont widthForText:self.patternAttribute.text andFontSize:[UIFont fontWithName:self.patternAttribute.textFontName size:self.patternAttribute.textFontSize] andHeight:20] + 58;
//        self.frame = CGRectMake(self.patternAttribute.frame.origin.x, self.patternAttribute.frame.origin.y, width + 26, 52 + 26);
//        self.patternAttribute.frame = self.frame;
//        
//    }
//    [super updateContent];
//}

@end
