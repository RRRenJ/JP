//
//  JPCalibratView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/6/12.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPCalibratView.h"

@interface JPCalibratView()

@end

@implementation JPCalibratView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *nib = [JPResourceBundle loadNibNamed:@"JPCalibratView" owner:self options:nil];
        JPCalibratView *_myView = (JPCalibratView *)[nib objectAtIndex:0];
        self = _myView;
    }
    return self;
}

@end
