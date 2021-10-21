//
//  JPPackageNinthTextPatternInteractiveView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/6/9.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageNinthTextPatternInteractiveView.h"
#import "JPPackageNinthTextPattern.h"

@interface JPPackageNinthTextPatternInteractiveView(){
    JPPackageNinthTextPattern *textPatternView;
}

@end

@implementation JPPackageNinthTextPatternInteractiveView

- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute{
    [super setPatternAttribute:patternAttribute];
    if (textPatternView == nil) {
        textPatternView = [[JPPackageNinthTextPattern alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        self.contentView = textPatternView;
    }
    textPatternView.patternAttribute = patternAttribute;

}

@end
