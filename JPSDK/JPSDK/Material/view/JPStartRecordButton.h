//
//  JPStartRecordButton.h
//  jper
//
//  Created by FoundaoTEST on 2017/6/1.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPStartRecordButton : UIButton
- (void)endRecord;
- (void)updateProgressWithTime:(CMTime)time;
@end
