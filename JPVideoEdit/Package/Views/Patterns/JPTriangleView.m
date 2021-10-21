//
//  JPTriangleView.m
//  jper
//
//  Created by FoundaoTEST on 2017/4/25.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPTriangleView.h"

@implementation JPTriangleView



- (void)drawRect:(CGRect)rect {
    //获得处理的上下文
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, 0, rect.size.height / 2.0);
    
    CGContextAddLineToPoint(context, rect.size.width, 0);
    
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    
    
    
    
    
    CGContextClosePath(context);
    
    [self.drawColor setStroke];
    
    [self.drawColor setFill];
    
    CGContextDrawPath(context, kCGPathFillStroke);

}


@end
