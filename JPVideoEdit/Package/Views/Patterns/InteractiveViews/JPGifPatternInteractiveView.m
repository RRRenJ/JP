//
//  JPGifPatternInteractiveView.m
//  jper
//
//  Created by FoundaoTEST on 2017/11/14.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPGifPatternInteractiveView.h"
#import "JPGifContentView.h"

@interface JPGifPatternInteractiveView () {
    JPGifContentView *imgView;
}

@end

@implementation JPGifPatternInteractiveView

#pragma mark - public methods

- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute
{
    [super setPatternAttribute:patternAttribute];
    if (!imgView) {
        imgView = [[JPGifContentView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        self.contentView = imgView;
    }
    imgView.patternAttribute = patternAttribute;
}

- (void)updateContent
{
    [super updateContent];
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if (hidden == YES) {
        [imgView dismiss];
    }else{
        [imgView show];
    }
}
@end
