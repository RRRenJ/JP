//
//  JPPackageHollowOutInteractiveView.m
//  jper
//
//  Created by FoundaoTEST on 2017/6/6.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageHollowOutInteractiveView.h"
#import "JPPackageHollowOutView.h"
@interface JPPackageHollowOutInteractiveView () {
    JPPackageHollowOutView *imgView;
}

@end

@implementation JPPackageHollowOutInteractiveView

- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute
{
    [super setPatternAttribute:patternAttribute];
    if (!imgView) {
        imgView = [[JPPackageHollowOutView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        self.contentView = imgView;
    }
    imgView.patternAttribute = patternAttribute;
}

//- (void)updateContent
//{
//    imgView.attribute = self.patternAttribute;
//    self.frame = self.patternAttribute.frame;
//    [super updateContent];
//}

@end
