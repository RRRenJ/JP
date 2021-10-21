//
//  JPImgPickerViewController.h
//  jper
//
//  Created by 藩 亜玲 on 2017/4/7.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPBaseViewController.h"

@interface JPImgPickerViewController : JPBaseViewController
@property (nonatomic, copy) void(^imagePickerCompletion)(NSArray *imageArr);
@property (nonatomic, assign) BOOL isSelectOneImage;
@end
