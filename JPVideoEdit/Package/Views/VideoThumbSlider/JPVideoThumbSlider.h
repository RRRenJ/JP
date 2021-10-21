//
//  JPVideoThumbSlider.h
//  jper
//
//  Created by 藩 亜玲 on 2017/5/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPVideoThumbSliderDelegate <NSObject>

- (void)didChangedToTime:(CMTime)currentTime;
- (void)compositionAssetDidLoad:(NSArray *)imageArr;
@end

@interface JPVideoThumbSlider : UIView
@property (nonatomic, weak) id<JPVideoThumbSliderDelegate>delegate;
- (id)initWithFrame:(CGRect)frame withAsset:(AVAsset *)asset andVideoDuration:(CMTime)dur andTotalDuration:(CMTime)totalDuration;
- (void)scrollToTime:(CMTime)time;
@property (assign, nonatomic) CMTime currentTime;
@end
