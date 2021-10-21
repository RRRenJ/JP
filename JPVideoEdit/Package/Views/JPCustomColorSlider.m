//
//  JPCustomColorSlider.m
//  jper
//
//  Created by 藩 亜玲 on 2017/3/30.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPCustomColorSlider.h"
#import "JPUtil.h"

@interface JPCustomColorSlider ()<UIGestureRecognizerDelegate> {
    NSArray *colorArray;
    UIView *thumbView;
    UIView *_containerView;
}

- (void)createUI;
- (void)calculateAppropriateSelectorXposition:(UIView *)view;

@end

@implementation JPCustomColorSlider

- (id)initWithFrame:(CGRect)frame withColors:(NSArray *)colorArr{
    self = [super initWithFrame:frame];
    if (self) {
        colorArray = colorArr;
        [self createUI];
    }
    return self;
}

#pragma mark - public methods

- (void)createUI {
    if (![colorArray count]) {
        return;
    }
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 4.5, self.width, (self.height - 9)/2)];
    [JPUtil setViewRadius:containerView byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(containerView.height/2, containerView.height/2)];
    [self addSubview:containerView];
    _containerView = containerView;
    float w = containerView.width/[colorArray count];
    for (int i = 0; i < [colorArray count]; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*w, 0, w, containerView.height)];
        view.tag = i;
        view.backgroundColor = [colorArray objectAtIndex:i];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [singleTap setNumberOfTapsRequired:1];
        [view addGestureRecognizer:singleTap];
        [containerView addSubview:view];
    }
    
    thumbView = [[UIView alloc] initWithFrame:CGRectMake(0, 4.5, w, self.height - 9)];
    thumbView.backgroundColor = [colorArray objectAtIndex:0];
    thumbView.layer.borderColor = [UIColor whiteColor].CGColor;
    thumbView.layer.borderWidth = 1.f;
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panRecognizer.minimumNumberOfTouches = 1;
    panRecognizer.delegate = self;
    [thumbView addGestureRecognizer:panRecognizer];
    containerView.centerY = thumbView.centerY;
    [self addSubview:thumbView];
}

- (void)setColorIndex:(NSInteger)index
{
    UIView *view = [_containerView viewWithTag:index];
    if (view) {
        float w = _containerView.width/[colorArray count];
        
        thumbView.frame = CGRectMake(index*w, 4.5, w, self.height - 9);
        thumbView.backgroundColor = [colorArray objectAtIndex:index];
    }
}
#pragma mark - Calculate position

- (void)calculateAppropriateSelectorXposition:(UIView *)view{
    float w = self.width/[colorArray count];
    float selectorViewX = view.frame.origin.x;
    int p = ceilf(selectorViewX/w);
    selectorViewX = w*p;
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    CGRect viewFrame = view.frame;
    viewFrame.origin.x = selectorViewX;
    view.frame = viewFrame;
    thumbView.backgroundColor = [colorArray objectAtIndex:p];
    [UIView commitAnimations];
    if (self.valueChangeBlock) {
        self.valueChangeBlock(p,  [colorArray objectAtIndex:p]);
    }
}

#pragma mark - actions

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    //Accessing tapped view
    float tappedViewX = recognizer.view.frame.origin.x;
    //Moving one place to another place animation
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    CGRect thumbFrame = thumbView.frame;
    thumbFrame.origin.x = tappedViewX;
    thumbView.frame = thumbFrame;
    thumbView.backgroundColor = [colorArray objectAtIndex:recognizer.view.tag];
    [UIView commitAnimations];
    [self calculateAppropriateSelectorXposition:recognizer.view];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self];
    CGFloat newX = MIN(recognizer.view.frame.origin.x + translation.x, self.frame.size.width - recognizer.view.frame.size.width);
    newX = MAX(0, newX);
    CGRect newFrame = CGRectMake( newX,recognizer.view.frame.origin.y, recognizer.view.frame.size.width, recognizer.view.frame.size.height);
    recognizer.view.frame = newFrame;
    [recognizer setTranslation:CGPointZero inView:self];
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self calculateAppropriateSelectorXposition:recognizer.view];
    }
}

@end
