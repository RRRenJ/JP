//
//  JPPackageMenuView.h
//  jper
//
//  Created by 藩 亜玲 on 2017/3/24.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPPackageMenuBaseView.h"

@protocol JPPackageTextPatternMenuViewDelegate <NSObject>

- (void)packageTextPatternMenuViewSelectedGraphWithData:(JPPackagePatternAttribute *)data;

- (void)hideTextMenu;

@end

@interface JPPackageTextPatternMenuView : JPPackageMenuBaseView

@property (nonatomic, weak) id<JPPackageTextPatternMenuViewDelegate>delegate;

@end
