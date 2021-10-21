//
//  JPPatternInputView.h
//  jper
//
//  Created by 藩 亜玲 on 2017/6/6.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPPatternInteractiveView.h"

@protocol JPPatternInputViewDelegate <NSObject>

- (void)patternInputViewWillDismiss;

@end

@interface JPPatternInputView : UIView

@property (nonatomic, weak) id<JPPatternInputViewDelegate>delegate;

- (void)showWithPatternInteractiveView:(JPPatternInteractiveView *)patternInteractiveView;

- (void)dismiss;

@end
