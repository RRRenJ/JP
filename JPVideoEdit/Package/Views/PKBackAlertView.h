//
//  PKBackAlertView.h
//  jper
//
//  Created by RRRenJ on 2020/8/5.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKBackAlertView : UIView

@property (nonatomic, copy) void(^comfirmBlock)();


- (void)show;



@end

NS_ASSUME_NONNULL_END
