//
//  JPPackageGraphPatternView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/4/15.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageGraphPatternView.h"
#import "JPPackageGraphView.h"

@interface JPPackageGraphPatternView(){
    JPPackageGraphView *graphView;
}

@end

@implementation JPPackageGraphPatternView

- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute{
    [super setPatternAttribute:patternAttribute];
    if (graphView == nil) {
        graphView = [[JPPackageGraphView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) withGraphType:patternAttribute];
        self.contentView = graphView;
    }
    graphView.patternAttribute = patternAttribute;
}

//- (void)updateContent{
//    graphView.patternAttribute = self.patternAttribute;
//    if (self.patternAttribute.patternType == JPPackagePatternTypeDate) {
//        self.frame = CGRectMake(self.patternAttribute.frame.origin.x, self.patternAttribute.frame.origin.y, 80 + 26, 108 + 26);
//        self.patternAttribute.frame = self.frame;
//    }else if (self.patternAttribute.patternType == JPPackagePatternTypeWeather)
//    {
//        self.frame = CGRectMake(self.patternAttribute.frame.origin.x, self.patternAttribute.frame.origin.y, 90 + 26, 108 + 26);
//        self.patternAttribute.frame = self.frame;
//
//    }else{
//        self.frame = CGRectMake(self.patternAttribute.frame.origin.x, self.patternAttribute.frame.origin.y, 80 + 26, 108 + 26);
//        self.patternAttribute.frame = self.frame;
//
//    }
//    [super updateContent];
//}

@end
