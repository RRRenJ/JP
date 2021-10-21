//
//  JPPackageGraphView.h
//  jper
//
//  Created by 藩 亜玲 on 2017/4/10.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPPackageSuperView.h"

typedef NS_ENUM(NSInteger, JPPackageWeekDayType) {
    JPPackageWeekDayTypeSunday= 1,
    JPPackageWeekDayTypeMonday,
    JPPackageWeekDayTypeTuesday,
    JPPackageWeekDayTypeWednesday,
    JPPackageWeekDayTypeThursday,
    JPPackageWeekDayTypeFriday,
    JPPackageWeekDayTypeSaturday
};
@interface JPPackageGraphView : JPPackageSuperView

- (id)initWithFrame:(CGRect)frame withGraphType:(JPPackagePatternAttribute *)patternAttribute;

@end
