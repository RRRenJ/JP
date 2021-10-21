//
//  JPLocalGraphList.h
//  jper
//
//  Created by 藩 亜玲 on 2017/7/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPLocalGraphListDelegate <NSObject>

- (void)toPicturePickerView;

- (void)selectedGraphWithData:(JPPackagePatternAttribute *)data;

@end

@interface JPLocalGraphList : UIView

@property (nonatomic, weak) id<JPLocalGraphListDelegate>delegate;

@end
