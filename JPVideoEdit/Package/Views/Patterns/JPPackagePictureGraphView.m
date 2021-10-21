//
//  JPPackagePictureGraphView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/4/12.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackagePictureGraphView.h"
#import "JPPackageImageView.h"
@interface JPPackagePictureGraphView () {
    JPPackageImageView *imgView;
}

@end

@implementation JPPackagePictureGraphView

#pragma mark - public methods


- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute
{
    [super setPatternAttribute:patternAttribute];
    if (!imgView) {
        imgView = [[JPPackageImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        self.contentView = imgView;
    }
    imgView.patternAttribute = patternAttribute;
}

//- (void)updateContent
//{
//    imgView.attribute = self.patternAttribute;
//    if (imgView.attribute.patternType != JPPackagePatternTypeWeekPicture) {
//        CGSize imageSize = self.patternAttribute.thumPicture.size;
//        CGSize reallySize = CGSizeMake(50,( 50 / imageSize.width) * imageSize.height);
//        self.frame = CGRectMake(self.patternAttribute.frame.origin.x, self.patternAttribute.frame.origin.y, reallySize.width + 26, reallySize.height + 26);
//        self.patternAttribute.frame = self.frame;
//    }else{
//        self.frame = self.patternAttribute.frame;
//    }
//    [super updateContent];
//}

@end
