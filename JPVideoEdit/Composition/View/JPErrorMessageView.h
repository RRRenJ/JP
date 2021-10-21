//
//  JPErrorMessageView.h
//  jper
//
//  Created by FoundaoTEST on 2017/8/8.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,JPErrorMessageViewType)
{
    JPErrorMessageViewTypeNetwork,
    JPErrorMessageViewTypeComposition,
    JPErrorMessageViewTypeVideoInfo,//视频上传成功，但是视频信息提交失败
    JPErrorMessageViewTypeMemey
};

@class JPErrorMessageView;
@protocol JPErrorMessageViewDelegate <NSObject>

- (void)errorViewWillDismiss:(JPErrorMessageView *)errorView;

@end

@interface JPErrorMessageView : UIView
@property (nonatomic, weak) id<JPErrorMessageViewDelegate>delegate;
- (instancetype)initWithErrorType:(JPErrorMessageViewType)errorType;
@property (nonatomic) JPErrorMessageViewType errorType;
@end
