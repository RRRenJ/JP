//
//  JPPackageMenuCollectionViewCell.m
//  jper
//
//  Created by 藩 亜玲 on 2017/3/28.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageGraphMenuCell.h"
#import "JPPackageGraphView.h"
@interface JPPackageGraphMenuCell() {
    UIView *subView;
}

@end

@implementation JPPackageGraphMenuCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

    }
    
    return self;
}

#pragma mark -

- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute{
    if (patternAttribute == _patternAttribute) {
        return;
    }
    _patternAttribute = patternAttribute;
    [subView removeFromSuperview];
    subView = nil;
    subView = [[JPPackageGraphView alloc] initWithFrame:self.bounds withGraphType:_patternAttribute];
    [self.contentView addSubview:subView];
}

@end
