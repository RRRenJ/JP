//
//  JPRecordButton.h
//  jper
//
//  Created by FoundaoTEST on 2017/3/29.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPRecordButton : UIButton
@property (nonatomic, assign) NSInteger duration;
- (void)becomeNone;
- (void)startScrollFilter;
- (void)endScrollFilter;
@end
