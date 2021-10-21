//
//  JPCompositionMessageView.h
//  jper
//
//  Created by FoundaoTEST on 2017/8/1.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPCompositionMessageViewDelegate <NSObject>

- (void)compositionMessageViewWillComposition;

@end

@interface JPCompositionMessageView : UIView

@property (nonatomic, weak) id <JPCompositionMessageViewDelegate>delegate;
- (void)show;
- (void)dismiss;
@end
