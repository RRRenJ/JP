//
//  JPPackageSuperView.h
//  jper
//
//  Created by FoundaoTEST on 2017/4/18.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JPPackageSuperView : UIView
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign)  NSInteger textFontSize;
@property (nonatomic, weak) JPPackagePatternAttribute *patternAttribute;
- (CGSize)getMyReallySizeWithPackagePatternAttribute:(JPPackagePatternAttribute *)patternAttribute andScale:(CGFloat)scale;
@end
