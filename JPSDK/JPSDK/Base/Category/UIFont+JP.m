//
//  UIFont+JP.m
//  JPSDK
//
//  Created by 任敬 on 2021/9/22.
//

#import "UIFont+JP.h"

@implementation UIFont (JP)

+ (UIFont *)jp_pingFangWithSize:(CGFloat)size {
    return [self jp_pingFangWithSize:size weight:UIFontWeightRegular];
}

+ (UIFont *)jp_pingFangWithSize:(CGFloat)size weight:(UIFontWeight)weight{
    UIFont * font ;
    if (weight == UIFontWeightThin) {
        font = [UIFont fontWithName:@"PingFangSC-Thin" size:size];
    }else if(weight == UIFontWeightUltraLight){
        font = [UIFont fontWithName:@"PingFangSC-Ultralight" size:size];
    }else if(weight == UIFontWeightLight){
        font = [UIFont fontWithName:@"PingFangSC-Light" size:size];
    }else if(weight == UIFontWeightRegular){
        font = [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    }else if(weight == UIFontWeightMedium){
        font = [UIFont fontWithName:@"PingFangSC-Medium" size:size];
    }else if(weight == UIFontWeightSemibold){
        font = [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
    }else{
        font = [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    }
    return font;
}


+ (UIFont *)jp_placardMTStdCondBoldFontWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"PlacardMTStd-Cond" size:size];
}

+ (UIFont *)titleFont{
    return [UIFont boldSystemFontOfSize:16];
}

+ (UIFont *)EnglishTitleFont{
    return [UIFont fontWithName:@"PlacardMTStd-Cond" size:16];
}

+ (UIFont *)contentFont{
    return [UIFont systemFontOfSize:12];
}

+ (UIFont *)EnglishContentFont{
    return [UIFont fontWithName:@"PlacardMTStd-Cond" size:12];
}


+ (CGFloat)jp_widthForText:(NSString *)text andFontSize:(UIFont *)font andHeight:(CGFloat)height{
    CGRect rect=[text boundingRectWithSize:CGSizeMake(30000, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    return ceilf(rect.size.width);
}

@end
