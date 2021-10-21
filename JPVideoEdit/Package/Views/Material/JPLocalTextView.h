//
//  JPLocalTextView.h
//  jper
//
//  Created by FoundaoTEST on 2017/8/1.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JPJPLocalTextViewDelegate <NSObject>

- (void)localTextViewSelectedGraphWithData:(JPPackagePatternAttribute *)data;

@end

@interface JPLocalTextView : UIView

@property (nonatomic, weak) id<JPJPLocalTextViewDelegate>delegate;

@end
