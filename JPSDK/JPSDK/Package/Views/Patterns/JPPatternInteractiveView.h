//
//  JPPatternInteractiveView.h
//  jper
//
//  Created by 藩 亜玲 on 2017/4/12.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPPackageSuperView.h"
@class JPPatternInteractiveView;
@protocol JPPatternInteractiveViewDelegate <NSObject>

- (void)patternInteractiveViewDidBeginEditing:(JPPatternInteractiveView *)sticker;
- (void)patternInteractiveViewDidEndEditing:(JPPatternInteractiveView *)sticker;
- (void)patternInteractiveViewDidCancelEditing:(JPPatternInteractiveView *)sticker;
- (void)patternInteractiveViewDidClose:(JPPatternInteractiveView *)sticker;
- (void)patternInteractiveViewWillMove:(JPPatternInteractiveView *)sticker;
- (void)patternInteractiveViewEndMove:(JPPatternInteractiveView *)sticker;
@end


@interface JPPatternInteractiveView : UIView

@property (weak, nonatomic) JPPackageSuperView *contentView;
@property (nonatomic) BOOL preventsPositionOutsideSuperview; //default = YES
@property (nonatomic) BOOL preventsResizing; //default = NO
@property (nonatomic) BOOL preventsDeleting; //default = NO
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat minHeight;
@property (nonatomic, weak) JPPackagePatternAttribute *patternAttribute;

@property (nonatomic, assign) CMTimeRange apearTimeRange;
@property (weak, nonatomic) id <JPPatternInteractiveViewDelegate> delegate;
@property (nonatomic, assign) CGFloat ratio;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) BOOL changeHidden;
- (void)hideDelHandle;
- (void)showDelHandle;
- (void)hideEditingHandles;
- (void)showEditingHandles;
- (void)updateContent;
@end

@interface JPBorderView : UIView

@end
