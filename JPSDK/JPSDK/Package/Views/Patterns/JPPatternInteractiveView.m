//
//  JPPatternInteractiveView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/4/12.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPatternInteractiveView.h"

#define kUserResizableViewGlobalInset 11.0
#define kUserResizableViewDefaultMinWidth 48.0
#define kUserResizableViewInteractiveBorderSize 10.0
#define kJPPatternInteractiveViewControlSize 22.0

@interface JPPatternInteractiveView() {
    UIView *borderView;
    BOOL isGloabal;
}

@property (strong, nonatomic) UIImageView *resizingControl;
@property (strong, nonatomic) UIImageView *deleteControl;

@property (nonatomic) BOOL preventsLayoutWhileResizing;

@property (nonatomic) float deltaAngle;
@property (nonatomic) CGPoint prevPoint;
@property (nonatomic) CGAffineTransform startTransform;

@property (nonatomic) CGPoint touchStart;

- (void)createUI;
- (void)translateUsingTouchLocation:(CGPoint)touchPoint;

@end

@implementation JPPatternInteractiveView
@synthesize contentView, touchStart;

@synthesize prevPoint;
@synthesize deltaAngle, startTransform; //rotation
@synthesize resizingControl, deleteControl;
@synthesize preventsPositionOutsideSuperview;
@synthesize preventsResizing;
@synthesize preventsDeleting;
@synthesize minWidth, minHeight;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self createUI];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self createUI];
    }
    return self;
}

#pragma mark -

- (void)setContentView:(JPPackageSuperView *)newContentView {
    [contentView removeFromSuperview];
    contentView = newContentView;
    contentView.clipsToBounds = YES;
    contentView.frame = CGRectInset(self.bounds, kUserResizableViewGlobalInset + kUserResizableViewInteractiveBorderSize/2, kUserResizableViewGlobalInset + kUserResizableViewInteractiveBorderSize/2);
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:contentView];
    CGFloat pading = 13.f;
    if (_patternAttribute.patternType == JPPackagePatternTypeHollowOutPicture || JPPackagePatternTypeWeekPicture == _patternAttribute.patternType) {
        pading = 0.f;
    }
    contentView.sd_layout.topSpaceToView(self, pading).bottomSpaceToView(self, pading).rightSpaceToView(self, pading).leftSpaceToView(self, pading);
    [self bringSubviewToFront:borderView];
    [self bringSubviewToFront:resizingControl];
    [self bringSubviewToFront:deleteControl];
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    self.contentView.scale = scale;
}

- (void)setFrame:(CGRect)newFrame {
    [super setFrame:newFrame];
    //    CGRect bounds = CGRectMake(0, 0, newFrame.size.width, newFrame.size.height);
    //    contentView.frame = CGRectInset(bounds, kUserResizableViewGlobalInset + kUserResizableViewInteractiveBorderSize/2, kUserResizableViewGlobalInset + kUserResizableViewInteractiveBorderSize/2);
    //
    //    borderView.frame = CGRectInset(bounds, kUserResizableViewGlobalInset, kUserResizableViewGlobalInset);
    //    resizingControl.frame =CGRectMake(bounds.size.width-kJPPatternInteractiveViewControlSize,
    //                                      bounds.size.height-kJPPatternInteractiveViewControlSize,
    //                                      kJPPatternInteractiveViewControlSize,
    //                                      kJPPatternInteractiveViewControlSize);
    //    deleteControl.frame = CGRectMake(0, 0,
    //                                     kJPPatternInteractiveViewControlSize, kJPPatternInteractiveViewControlSize);
    //    [borderView setNeedsDisplay];
}

#pragma mark - public methods

- (void)translateUsingTouchLocation:(CGPoint)touchPoint {
    if (self.patternAttribute.patternType == JPPackagePatternTypeHollowOutPicture || self.patternAttribute.patternType == JPPackagePatternTypeWeekPicture) {
        return;
    }
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - touchStart.x,
                                    self.center.y + touchPoint.y - touchStart.y);
    if (self.preventsPositionOutsideSuperview) {
        // Ensure the translation won't cause the view to move offscreen.
        CGFloat midPointX = CGRectGetMidX(self.bounds) - 13;
        if (newCenter.x > self.superview.bounds.size.width - midPointX) {
            newCenter.x = self.superview.bounds.size.width - midPointX;
        }
        if (newCenter.x < midPointX) {
            newCenter.x = midPointX;
        }
        CGFloat midPointY = CGRectGetMidY(self.bounds) - 13;
        if (newCenter.y > self.superview.bounds.size.height - midPointY) {
            newCenter.y = self.superview.bounds.size.height - midPointY;
        }
        if (newCenter.y < midPointY) {
            newCenter.y = midPointY;
        }
    }
    self.center = newCenter;
    _patternAttribute.frame = self.frame;
}

- (void)createUI {
    self.clipsToBounds = YES;
    _apearTimeRange = kCMTimeRangeZero;
    borderView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:borderView];
    borderView.layer.borderWidth = 2;
    borderView.layer.borderColor = [UIColor whiteColor].CGColor;
    borderView.layer.masksToBounds = YES;
    borderView.sd_layout.topSpaceToView(self, kUserResizableViewGlobalInset).rightSpaceToView(self,     kUserResizableViewGlobalInset).leftSpaceToView(self, kUserResizableViewGlobalInset).bottomSpaceToView(self, kUserResizableViewGlobalInset);
    //    if (kUserResizableViewDefaultMinWidth > self.bounds.size.width*0.5) {
    //        self.minWidth = kUserResizableViewDefaultMinWidth;
    //        self.minHeight = self.bounds.size.height * (kUserResizableViewDefaultMinWidth/self.bounds.size.width);
    //    } else {
    //        self.minWidth = self.bounds.size.width*0.5;
    //        self.minHeight = self.bounds.size.height*0.5;
    //    }
    self.preventsPositionOutsideSuperview = YES;
    self.preventsLayoutWhileResizing = YES;
    self.preventsResizing = NO;
    self.preventsDeleting = NO;
    
    deleteControl = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                                 kJPPatternInteractiveViewControlSize, kJPPatternInteractiveViewControlSize)];
    deleteControl.backgroundColor = [UIColor clearColor];
    deleteControl.image = JPImageWithName(@"delete_pattern");
    deleteControl.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(singleTap:)];
    [deleteControl addGestureRecognizer:singleTap];
    [self addSubview:deleteControl];
    deleteControl.sd_layout.topEqualToView(self).leftEqualToView(self).heightIs(kJPPatternInteractiveViewControlSize).widthIs(kJPPatternInteractiveViewControlSize);
    resizingControl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-kJPPatternInteractiveViewControlSize,
                                                                   self.frame.size.height-kJPPatternInteractiveViewControlSize,
                                                                   kJPPatternInteractiveViewControlSize, kJPPatternInteractiveViewControlSize)];
    resizingControl.backgroundColor = [UIColor clearColor];
    resizingControl.userInteractionEnabled = YES;
    resizingControl.image = JPImageWithName(@"zoom_pattern");
    UIPanGestureRecognizer* panResizeGesture = [[UIPanGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(resizeTranslate:)];
    [resizingControl addGestureRecognizer:panResizeGesture];
    [self addSubview:resizingControl];
    resizingControl.sd_layout.bottomEqualToView(self).rightEqualToView(self).heightIs(kJPPatternInteractiveViewControlSize).widthIs(kJPPatternInteractiveViewControlSize);
    deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                       self.frame.origin.x+self.frame.size.width - self.center.x);
    resizingControl.hidden = YES;
    resizingControl.userInteractionEnabled = NO;
    
    UIPanGestureRecognizer *recg = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:recg];
}

- (void)hideDelHandle{
    deleteControl.hidden = YES;
}

- (void)showDelHandle{
    deleteControl.hidden = NO;
}

- (void)hideEditingHandles
{
    resizingControl.hidden = YES;
    deleteControl.hidden = YES;
    [borderView setHidden:YES];
}

- (void)showEditingHandles{
    deleteControl.hidden = NO;
    [borderView setHidden:NO];
}


#pragma mark - touches
/*
 - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
 UITouch *touch = [touches anyObject];
 touchStart = [touch locationInView:self.superview];
 if([_delegate respondsToSelector:@selector(patternInteractiveViewDidBeginEditing:)]) {
 [_delegate patternInteractiveViewDidBeginEditing:self];
 }
 }
 
 - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
 // Notify the delegate we've ended our editing session.
 if([_delegate respondsToSelector:@selector(patternInteractiveViewDidEndEditing:)]) {
 [_delegate patternInteractiveViewDidEndEditing:self];
 }
 }
 
 - (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
 // Notify the delegate we've ended our editing session.
 if([_delegate respondsToSelector:@selector(patternInteractiveViewDidCancelEditing:)]) {
 [_delegate patternInteractiveViewDidCancelEditing:self];
 }
 }
 
 - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
 CGPoint touch = [[touches anyObject] locationInView:self.superview];
 [self translateUsingTouchLocation:touch];
 touchStart = touch;
 }*/

#pragma mark - actions

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            if(_delegate && [_delegate respondsToSelector:@selector(patternInteractiveViewWillMove:)]) {
                [_delegate patternInteractiveViewWillMove:self];
            }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint p = [sender translationInView:self];
            CGPoint movedPoint = CGPointMake(self.center.x + p.x, self.center.y + p.y);
            self.center = movedPoint;
            [sender setTranslation:CGPointZero inView:self];
            if (self.centerX < 0) {
                self.centerX = 0;
            }
            if (self.centerX > self.superview.width) {
                self.centerX = self.superview.width;
            }
            if (self.centerY < 0) {
                self.centerY = 0;
            }
            if (self.centerY > self.superview.height) {
                self.centerY = self.superview.height;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:{
            CGFloat animateDuration = 0.3;
            CGFloat boundaryCenterX = CGRectGetMidX(self.superview.bounds);
            CGFloat boundaryCenterY = CGRectGetMidY(self.superview.bounds);
            CGFloat centerX = CGRectGetMidX(self.frame);
            CGFloat centerY = CGRectGetMidY(self.frame);
            CGFloat boundaryXRight = CGRectGetMaxX(self.superview.bounds);
            
            CGFloat boundaryYBottom = CGRectGetMaxY(self.superview.bounds);
            CGFloat oriLeft = self.left;
            CGFloat oriTop = self.top;
            CGFloat oriRight = self.right;
            CGFloat oriBottom = self.bottom;
            CGFloat boundaryY = self.superview.bottom;
            CGPoint center = self.center;
            CGRect frame = self.frame;
            if (fabs(centerY - boundaryCenterY) < 15) {
                center.y = boundaryCenterY;
            }
            if (fabs(centerX - boundaryCenterX)< 15) {
                center.x = boundaryCenterX;
            }
            if (fabs(oriLeft) < 10) {
                frame.origin.x = 0;
                frame.origin.y = [self _getAdjustY:self];
            }
            if (fabs(oriRight - boundaryXRight) < 10) {
                frame.origin.x = [self _getAdjustX:self];
                frame.origin.y = [self _getAdjustY:self];
            }
            if (fabs(oriTop) < 10) {
                frame.origin.y = 0;
                frame.origin.x = [self _getAdjustX:self];
            }
            if (fabs(oriBottom - boundaryYBottom) < 10) {
                frame.origin.y = [self _getAdjustY:self];
            }
            if (oriBottom > boundaryY){
                frame.origin.y = boundaryY - self.height;
            }
            [UIView animateWithDuration:animateDuration animations:^{
                self.center = center;
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:animateDuration animations:^{
                        self.frame = frame;
                    } completion:^(BOOL finished) {
                        if (finished) {
                            self.patternAttribute.frame = self.frame;
                            if(self.delegate && [self.delegate respondsToSelector:@selector(patternInteractiveViewEndMove:)]) {
                                [self.delegate patternInteractiveViewEndMove:self];
                            }
                        }
                    }];
                }
            }];
        }
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"UIGestureRecognizerStateCancelled");
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"UIGestureRecognizerStateFailed");
            break;
        default:
            break;
    }
}

- (CGFloat)_getAdjustX:(UIView*)iconPlayerView {
    CGFloat adjustX = CGRectGetMinX(iconPlayerView.frame);
    if (CGRectGetMinX(iconPlayerView.frame) < CGRectGetMinX(self.superview.bounds)) {
        adjustX = CGRectGetMinX(self.superview.bounds);
    } else if (CGRectGetMaxX(iconPlayerView.frame) > CGRectGetMaxX(self.superview.bounds)) {
        adjustX = CGRectGetMaxX(self.superview.bounds) - CGRectGetWidth(iconPlayerView.frame);
    }
    return adjustX;
}

- (CGFloat)_getAdjustY:(UIView*)iconPlayerView {
    CGFloat adjustY = CGRectGetMinY(iconPlayerView.frame);
    if (CGRectGetMinY(iconPlayerView.frame) < CGRectGetMinY(self.superview.bounds)) {
        adjustY = CGRectGetMinY(self.superview.bounds);
    } else if (CGRectGetMaxY(iconPlayerView.frame) > CGRectGetMaxY(self.superview.bounds)) {
        adjustY = CGRectGetMaxY(self.superview.bounds) - CGRectGetHeight(iconPlayerView.frame);
    }
    
    return adjustY;
}

- (void)singleTap:(UIPanGestureRecognizer *)recognizer{
    if (NO == self.preventsDeleting) {
        UIView * close = (UIView *)[recognizer view];
        [close.superview removeFromSuperview];
    }
    
    if([_delegate respondsToSelector:@selector(patternInteractiveViewDidClose:)]) {
        [_delegate patternInteractiveViewDidClose:self];
    }
}

- (void)resizeTranslate:(UIPanGestureRecognizer *)recognizer{
    if (_patternAttribute.patternType != JPPackagePatternTypeWeekPicture && _patternAttribute.patternType != JPPackagePatternTypeDownloadedPicture) {
        return;
    }
    if ([recognizer state]== UIGestureRecognizerStateBegan){
        prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }else if ([recognizer state] == UIGestureRecognizerStateChanged){
        //        if (self.bounds.size.width < minWidth || self.bounds.size.width < minHeight){
        //            self.bounds = CGRectMake(self.bounds.origin.x,
        //                                     self.bounds.origin.y,
        //                                     minWidth,
        //                                     minHeight);
        ////            resizingControl.frame =CGRectMake(self.bounds.size.width-kJPPatternInteractiveViewControlSize,
        ////                                              self.bounds.size.height-kJPPatternInteractiveViewControlSize,
        ////                                              kJPPatternInteractiveViewControlSize,
        ////                                              kJPPatternInteractiveViewControlSize);
        ////            deleteControl.frame = CGRectMake(0, 0,
        ////                                             kJPPatternInteractiveViewControlSize, kJPPatternInteractiveViewControlSize);
        //            prevPoint = [recognizer locationInView:self];
        //
        //        }
        //        else {
        CGPoint point = [recognizer locationInView:self];
        float wChange = 0.0, hChange = 0.0;
        
        wChange = (point.x - prevPoint.x);
        hChange = (point.y - prevPoint.y);
        
        //            if (ABS(wChange) > 20.0f || ABS(hChange) > 20.0f) {
        //                prevPoint = [recognizer locationInView:self];
        //                return;
        //            }
        
        //            if (YES == self.preventsLayoutWhileResizing) {
        //                if (wChange < 0.0f && hChange < 0.0f) {
        //                    float change = MIN(wChange, hChange);
        //                    wChange = change;
        //                    hChange = change;
        //                }
        //                if (wChange < 0.0f) {
        //                    hChange = wChange;
        //                } else if (hChange < 0.0f) {
        //                    wChange = hChange;
        //                } else {
        //                    float change = MAX(wChange, hChange);
        //                    wChange = change;
        //                    hChange = change;
        //                }
        //            }
        
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                                 self.bounds.size.width + (wChange),
                                 self.bounds.size.height + (hChange));
        if (self.bounds.size.width <= minWidth) {
            self.width = minWidth;
        }
        if (self.bounds.size.height <= minHeight)
        {
            self.height = minHeight;
        }
        if (self.right >= self.superview.bounds.size.width + 13)
        {
            self.width = self.superview.bounds.size.width + 13 - self.left;
        }
        if (self.bottom >= self.superview.bounds.size.height + 13)
        {
            self.height = self.superview.bounds.size.height + 13 - self.top;
        }
        if (self.left <= -13)
        {
            self.left = -13;
        }
        if (self.top <= -13) {
            self.top = -13;
        }
        
        //            resizingControl.frame =CGRectMake(self.bounds.size.width-kJPPatternInteractiveViewControlSize,
        //                                              self.bounds.size.height-kJPPatternInteractiveViewControlSize,
        //                                              kJPPatternInteractiveViewControlSize, kJPPatternInteractiveViewControlSize);
        //            deleteControl.frame = CGRectMake(0, 0,
        //                                             kJPPatternInteractiveViewControlSize, kJPPatternInteractiveViewControlSize);
        prevPoint = [recognizer locationInView:self];
        //        }
        
        //        /* Rotation */
        //        float ang = atan2([recognizer locationInView:self.superview].y - self.center.y,
        //                          [recognizer locationInView:self.superview].x - self.center.x);
        //        float angleDiff = deltaAngle - ang;
        //        if (NO == preventsResizing) {
        //            self.transform = CGAffineTransformMakeRotation(-angleDiff);
        //           _ratio = _viewModel.ratio = - angleDiff;
        //        }
        
        //        borderView.frame = CGRectInset(self.bounds, kUserResizableViewGlobalInset, kUserResizableViewGlobalInset);
        //        [borderView setNeedsDisplay];
        CGRect frame = self.frame;
        if (self.width <= 50) {
            self.width = 50;
        }
        if (self.height <= 50) {
            self.height = 50;
        }
        if (frame.size.width > frame.size.height) {
            frame.size.height = (frame.size.width - 26) *_patternAttribute.originImgSize.height/_patternAttribute.originImgSize.width + 26;
        } else {
            frame.size.width = (frame.size.height - 26) *_patternAttribute.originImgSize.width/_patternAttribute.originImgSize.height + 26;
        }
        self.frame = frame;
        _patternAttribute.frame = self.frame;
        [self setNeedsDisplay];
    }else if ([recognizer state] == UIGestureRecognizerStateEnded){
        prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
}

- (void)setRatio:(CGFloat)ratio
{
    _ratio = ratio;
    //    self.transform = CGAffineTransformMakeRotation(ratio);
}

- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute
{
    _patternAttribute = patternAttribute;
    if (patternAttribute.patternType == JPPackagePatternTypeDownloadedPicture) {
        resizingControl.hidden = NO;
        resizingControl.userInteractionEnabled = YES;
    }
    else if (patternAttribute.patternType == JPPackagePatternTypeWeekPicture) {
        resizingControl.hidden = YES;
        deleteControl.hidden = YES;
        [borderView setHidden:YES];
        self.userInteractionEnabled = NO;
    }
}

- (void)updateContent{
    self.contentView.patternAttribute = self.patternAttribute;
    CGSize size = [self.contentView getMyReallySizeWithPackagePatternAttribute:self.patternAttribute andScale:1.0];
    self.frame = CGRectMake(self.patternAttribute.frame.origin.x, self.patternAttribute.frame.origin.y, size.width + 26, size.height + 26);
    self.patternAttribute.frame = self.frame;
    [self layoutIfNeeded];
}


- (void)setChangeHidden:(BOOL)changeHidden
{
    if (_changeHidden != changeHidden) {
        _changeHidden = changeHidden;
        CGFloat alpha = changeHidden == YES ? 0.0f : 1.0f;
        CGFloat time = changeHidden == YES ? 0.3f : 0.3f;
        [self.layer removeAllAnimations];
        [UIView animateWithDuration:time animations:^{
            self.alpha = alpha;
        }];
    }
}

@end

@implementation JPBorderView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Clear background to ensure the content view shows through.
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddRect(context, CGRectInset(self.bounds, kUserResizableViewInteractiveBorderSize/2, kUserResizableViewInteractiveBorderSize/2));
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}



@end
