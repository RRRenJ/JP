//
//  PKBackTipView.h
//  jper
//
//  Created by 赖星果 on 2019/12/6.
//  Copyright © 2019 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKBackTipView : UIView

@property (nonatomic, copy) void(^dismissCompletion)(BOOL left);
- (void)showInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
