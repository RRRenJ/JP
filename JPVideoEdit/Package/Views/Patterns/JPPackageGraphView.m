//
//  JPPackageGraphView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/4/10.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageGraphView.h"


@interface JPPackageGraphView(){
    JPPackagePatternAttribute * pattern;
}

- (void)createWeatherGraphUI;

- (void)createDateGraphUI;

- (void)createPositionGraphUI;

- (CGRect)calculateLbWidthWithStr:(NSString *)str AndFont:(UIFont *)f AndHeight:(CGFloat)h;

- (NSString *)convertWeekDayToString:(JPPackageWeekDayType)week;

- (UIImage *)savedAsPictureWithGraphType:(JPPackageGraphPatternType)type;
- (NSString *)getImgWithWeatherType:(JPWeatherType)type;



@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLineViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLineViewWidth;
@property (weak, nonatomic) IBOutlet UIView *dateBorderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateBorderViewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateBorderViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateBorderViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateBorderViewRight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLineViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weekLabelTop;

@property (strong, nonatomic) IBOutlet UIView *positinView;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *positionImageWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *positionImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *positionImageTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *positionLabelTop;

@property (strong, nonatomic) IBOutlet UIView *weatherView;

@property (weak, nonatomic) IBOutlet UILabel *coldLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coldLabelOriginX;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;

@property (weak, nonatomic) IBOutlet UILabel *weatherPositionLabel;


@end

@implementation JPPackageGraphView

- (id)initWithFrame:(CGRect)frame withGraphType:(JPPackagePatternAttribute *)patternAttribute {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        pattern = patternAttribute;
        switch (patternAttribute.patternType) {
            case JPPackagePatternTypeWeather:
                [self createWeatherGraphUI];
                break;
            case JPPackagePatternTypeDate:
                 [self createDateGraphUI];
                break;
            case JPPackagePatternTypePosition:
                [self createPositionGraphUI];
                break;
            default:
                break;
        }
    }
    return self;
}

#pragma mark - public

- (CGRect)calculateLbWidthWithStr:(NSString *)str AndFont:(UIFont *)f AndHeight:(CGFloat)h {
    CGRect rect = [str boundingRectWithSize:CGSizeMake(20000, h) options: NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:f} context:nil];
    return rect;
}

- (NSString *)getImgWithWeatherType:(JPWeatherType)type {
    NSString *imgName = @"";
    switch (type) {
        case JPWeatherTypeSun:
            imgName = @"sun-1";
            break;
        case JPWeatherTypeCloudy:
            imgName = @"cloud";
            break;
        case JPWeatherTypeRain:
            imgName = @"rain";
            break;
        case JPWeatherTypeSnow:
            imgName = @"snow";
            break;
        default:
            break;
    }
    return imgName;
}

- (NSString *)convertWeekDayToString:(JPPackageWeekDayType)week {
    NSString *weekDay = @"";
    switch (week) {
        case JPPackageWeekDayTypeMonday:
            weekDay = @"MONDAY";
            break;
        case JPPackageWeekDayTypeTuesday:
            weekDay = @"TUESDAY";
            break;
        case JPPackageWeekDayTypeWednesday:
            weekDay = @"WEDNESDAY";
            break;
        case JPPackageWeekDayTypeThursday:
            weekDay = @"THURSDAY";
            break;
        case JPPackageWeekDayTypeFriday:
            weekDay = @"FRIDAY";
            break;
        case JPPackageWeekDayTypeSaturday:
            weekDay = @"SATURDAY";
            break;
        case JPPackageWeekDayTypeSunday:
            weekDay = @"SUNDAY";
            break;
        default:
            break;
    }
    return weekDay;
}

- (void)setScale:(CGFloat)scale
{
    scale = 1.0;
    [super setScale:scale];
    if (self.patternAttribute.patternType == JPPackagePatternTypePosition){
        self.positionImageWidth.constant = 50 * scale;
        self.positionImageHeight.constant = 58 * scale;
        self.positionImageTop.constant = 10 * scale;
        self.positionLabelTop.constant = 10 * scale;
        self.positionLabel.font = [UIFont systemFontOfSize:ceil(18 * scale)];
    }
}

- (void)createWeatherGraphUI {
    [JPResourceBundle loadNibNamed:@"JPPackageGraphView" owner:self options:nil];
    [self addSubview:self.weatherView];
    self.weatherView.sd_layout.topEqualToView(self).rightEqualToView(self).bottomEqualToView(self).leftEqualToView(self);
//    self.coldLabel.text = [JPSession sharedInstance].weatherCode;
//    NSLog(@"温度：%@", [JPSession sharedInstance].weatherCode);
    self.coldLabel.font = [UIFont jp_placardMTStdCondBoldFontWithSize:85];
//    self.weatherImageView.image = JPImageWithName([self getImgWithWeatherType:[JPSession sharedInstance].weatherType]);
//    NSLog(@"------%@", [JPSession sharedInstance].cityName);
//    self.weatherPositionLabel.text = [JPSession sharedInstance].cityName;
}

- (CGSize)getMyReallySizeWithPackagePatternAttribute:(JPPackagePatternAttribute *)patternAttribute andScale:(CGFloat)scale
{
    scale = 1.0;
    if (patternAttribute.patternType == JPPackagePatternTypeDate) {
//        [self setScale:scale];
//        [self.DateLabel sizeToFit];
//        [self.weekLabel sizeToFit];
//        [self layoutIfNeeded];
        CGFloat width1 = self.weekLabel.width + 40 * scale;
        CGFloat width2 = self.DateLabel.width + 40 * scale;
        CGFloat width = ceil(width1 > width2 ? width1 : width2);
        CGFloat height = ceil(self.DateLabel.bottom + (25 + 2 + 8) * scale);
        return CGSizeMake(width, height);
    }else if (patternAttribute.patternType == JPPackagePatternTypePosition)
    {
//        [self setScale:scale];
//        [self.positionLabel sizeToFit];
//        [self layoutIfNeeded];
        CGFloat height = ceil(self.positionLabel.bottom + (10) * scale);
        CGFloat width = [UIFont jp_widthForText:patternAttribute.text andFontSize:[UIFont fontWithName:patternAttribute.textFontName size:patternAttribute.textFontSize] andHeight:height] + 15 * scale;
        width = MAX(width, (50 + 15) * scale);
        return CGSizeMake(width, height);

    }else{
        scale = 1.0;
//        [self setScale:scale];
//        [self layoutIfNeeded];
        CGFloat width1 = self.unitLabel.right + 10 * scale;
        CGFloat width2 = self.weatherImageView.right + 10 * scale;
        CGFloat width3 = self.weatherPositionLabel.right + 10 * scale;
        CGFloat width = ceil(width1 > width2 ? width1 : width2);
        width = ceil(width > width3 ? width : width3);
        CGFloat height =70 + 20 * scale;
        return CGSizeMake(width, height);
    }
    
    return CGSizeZero;
}

- (void)createDateGraphUI {

    [JPResourceBundle loadNibNamed:@"JPPackageGraphView" owner:self options:nil];
    [self addSubview:self.dateView];
    self.dateView.sd_layout.topEqualToView(self).rightEqualToView(self).bottomEqualToView(self).leftEqualToView(self);
    self.dateBorderView.layer.masksToBounds = YES;
    self.dateBorderView.layer.borderWidth = 2;
    self.dateBorderView.layer.borderColor = [UIColor whiteColor].CGColor;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    unsigned unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|kCFCalendarUnitWeekday;
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    NSString *weekDayStr = [self convertWeekDayToString:[components weekday]];
    NSString *dayStr = @"";
    if ([components day] < 10) {
        dayStr = [NSString stringWithFormat:@"0%ld",(long)[components day]];
    } else {
        dayStr = [NSString stringWithFormat:@"%ld",(long)[components day]];
    }
    _weekLabel.font = [UIFont jp_placardMTStdCondBoldFontWithSize:(15)];
    _weekLabel.text = weekDayStr;
    _DateLabel.font = [UIFont jp_placardMTStdCondBoldFontWithSize:(50)];
    _DateLabel.text = dayStr;
}

- (void)createPositionGraphUI {

    [JPResourceBundle loadNibNamed:@"JPPackageGraphView" owner:self options:nil];
    [self addSubview:self.positinView];
    self.positinView.sd_layout.topEqualToView(self).rightEqualToView(self).bottomEqualToView(self).leftEqualToView(self);
    self.positionLabel.font = [UIFont systemFontOfSize:18];
    self.positionLabel.text =  pattern.text;
}

- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute
{
    [super setPatternAttribute:patternAttribute];
    pattern = patternAttribute;
    if (patternAttribute.patternType == JPPackagePatternTypePosition) {
        self.positionLabel.text =  pattern.text;
        self.positionLabel.font = [UIFont fontWithName:patternAttribute.textFontName size:patternAttribute.textFontSize];
    }
}

- (UIImage *)savedAsPictureWithGraphType:(JPPackageGraphPatternType)type {
    return nil;
}

@end
