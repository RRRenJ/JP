//
//  JPGIFImageView.m
//  jper
//
//  Created by FoundaoTEST on 2017/11/16.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPGIFImageView.h"
@interface JPGIFImageView()
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong, readwrite) UIImage *currentFrame;
@end


@implementation JPGIFImageView

- (void)dealloc
{
    // Removes the display link from all run loop modes.
    [_displayLink invalidate];
}


- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute
{
    if (![_patternAttribute isEqual:patternAttribute]) {
        if (patternAttribute) {
            super.image = nil;
            super.highlighted = NO;
            [self invalidateIntrinsicContentSize];
        } else {
            [self stopAnimating];
        }
        _patternAttribute = patternAttribute;
        self.currentFrame = [patternAttribute getThumbImageForGifAtIndex:patternAttribute.gifPNGCount - 1];
        self.currentIndex = 0;
        [self.layer setNeedsDisplay];
    }
}

- (UIImage *)image
{
    UIImage *image = nil;
    if (self.patternAttribute) {
        // Initially set to the poster image.
        image = self.currentFrame;
    } else {
        image = super.image;
    }
    return image;
}

- (void)setImage:(UIImage *)image
{
    if (image) {
        // Clear out the animated image and implicitly pause animation playback.
        self.patternAttribute = nil;
    }
    
    super.image = image;
}

- (BOOL)isAnimating
{
    BOOL isAnimating = NO;
    if (self.patternAttribute) {
        isAnimating = self.displayLink && !self.displayLink.isPaused;
    } else {
        isAnimating = [super isAnimating];
    }
    return isAnimating;
}

- (void)startAnimating
{
    if (self.patternAttribute) {
        if (!self.displayLink) {
            // It is important to note the use of a weak proxy here to avoid a retain cycle. `-displayLinkWithTarget:selector:`
            // will retain its target until it is invalidated. We use a weak proxy so that the image view will get deallocated
            // independent of the display link's lifetime. Upon image view deallocation, we invalidate the display
            // link which will lead to the deallocation of both the display link and the weak proxy.
            __weak typeof(self) weakProxy = self;
            self.displayLink = [CADisplayLink displayLinkWithTarget:weakProxy selector:@selector(displayDidRefresh:)];
            [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        }
        self.displayLink.frameInterval = _patternAttribute.secondOfFrame + 2;
        self.displayLink.paused = NO;
    } else {
        [super startAnimating];
    }
}

- (void)stopAnimating
{
    if (self.patternAttribute) {
        self.displayLink.paused = YES;
    } else {
        [super stopAnimating];
    }
}

- (void)displayDidRefresh:(CADisplayLink *)displayLink
{
 
    UIImage *image = [_patternAttribute getThumbImageForGifAtIndex:_currentIndex];
    _currentIndex++;
    if (_currentIndex >= _patternAttribute.gifPNGCount) {
        _currentIndex = 0;
    }
    self.currentFrame = image;
    [self.layer setNeedsDisplay];
}




- (void)displayLayer:(CALayer *)layer
{
    layer.contents = (__bridge id)self.image.CGImage;
}

@end
