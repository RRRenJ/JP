//
//  JPGifListCellCollectionViewCell.m
//  jper
//
//  Created by FoundaoTEST on 2017/11/14.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPGifListCellCollectionViewCell.h"
#import "JPGIFImageView.h"

@interface JPGifListCellCollectionViewCell (){
    JPGIFImageView *thumImgView;
}

- (void)createUI;

@end

@implementation JPGifListCellCollectionViewCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

#pragma mark -

- (void)createUI {
    thumImgView = [[JPGIFImageView alloc] initWithFrame:CGRectZero];
    thumImgView.contentMode = UIViewContentModeScaleAspectFit;
    thumImgView.clipsToBounds = YES;
    [self.contentView addSubview:thumImgView];
    thumImgView.sd_layout.topEqualToView(self.contentView).bottomEqualToView(self.contentView).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
    
}


- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute
{
    _patternAttribute = patternAttribute;
//    thumImgView.image = [patternAttribute getlastImage];
    [thumImgView stopAnimating];
    thumImgView.patternAttribute = patternAttribute;
//    thumImgView.animationImages = [patternAttribute getAllThumbGifImage];
//    thumImgView.animationDuration = ((CGFloat)patternAttribute.gifPNGCount) / ((CGFloat)patternAttribute.secondOfFrame);     //执行一次完整动画所需的时长
//    thumImgView.animationRepeatCount = 0;  //动画重复次数
    [thumImgView startAnimating];
  
}


- (void)stopAnimation
{
    if (thumImgView.isAnimating) {
        [thumImgView stopAnimating];
    }
}

- (void)startAnimation
{
    if (!thumImgView.isAnimating) {
        [thumImgView startAnimating];

    }
}
@end
