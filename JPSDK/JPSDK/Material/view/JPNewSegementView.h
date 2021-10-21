//
//  JPNewSegementView.h
//  jper
//
//  Created by FoundaoTEST on 2017/6/2.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPNewSegementView : UIControl

@property (nonatomic, strong) NSArray <NSString *>* titles;
@property (nonatomic, assign) NSInteger cureenrIndex;

- (void)setCurrentIndex:(NSInteger)index;

@end
