//
//  JPAudioRecordingProgressView.h
//  jper
//
//  Created by 藩 亜玲 on 2017/4/18.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPAudioRecordingProgressView : UIView

- (void)updateViewWithProgress:(CGFloat)currentValue maxValue:(CGFloat)max;

@end
