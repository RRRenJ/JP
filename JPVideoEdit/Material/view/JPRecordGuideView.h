//
//  JPRecordGuideView.h
//  jper
//
//  Created by 藩 亜玲 on 2017/8/24.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPRecordGuideView : UIView

- (void)startAnimation;
- (void)removeGuide:(NSString *)str withAnimation:(BOOL)animation;
- (BOOL)hasAnimate;
@end
