//
//  JPUtil.m
//  jper
//
//  Created by 藩 亜玲 on 2017/3/24.
//  Copyright © 2017年 MuXiao. All rights reserved.
//
#import "JPUtil.h"
#import "NSString+JP.h"
#import "JPFilterManagers.h"
#import <CoreText/CoreText.h>

@implementation JPUtil


+ (NSBundle *)bundleWithName:(NSString *)name{
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"bundle"]];
    });
    return bundle;
}

+ (UIImage *)imageNamed:(NSString *)name withBundle:(NSBundle *)bundle{
    if (name.length == 0) return nil;

    UIImage * image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    
    return image;
}

+ (void)setViewRadius:(UIView *)view
    byRoundingCorners:(UIRectCorner)corners
          cornerRadii:(CGSize)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.layer.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

+ (UIButton *)createCustomButtonWithTittle:(NSString *)tittle
                                 withImage:(UIImage *)image
                                 withFrame:(CGRect)frame
                                    target:(id)target
                                    action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (image) {
        [btn setImage:image forState:UIControlStateNormal];
    }
    if (tittle) {
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:tittle forState:UIControlStateNormal];
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}






+ (BOOL)createJperFolder{
    if (![[NSFileManager defaultManager] fileExistsAtPath:JPER_RECORD_FILES_FOLDER]) {
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:JPER_RECORD_FILES_FOLDER
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error]){
            return NO;
        }
    }
    return YES;
}

+ (BOOL)createJperFolderInDocument{
    if (![[NSFileManager defaultManager] fileExistsAtPath:JP_MATERIAL_FILES_FOLDER]) {
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:JP_MATERIAL_FILES_FOLDER
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error]){
            return NO;
        }
    }
    return YES;
}

+ (void)loadCustomFont{
    [JPUtil registNewFontWithName:@"PlacardMTStd-Cond.otf"];
    [JPUtil registNewFontWithName:@"新蒂下午茶基本版.ttf"];
    [JPUtil registNewFontWithName:@"习宋体.ttf"];
    [JPUtil registNewFontWithName:@"TrajanPro-Bold.otf"];
    [JPUtil registNewFontWithName:@"Arista2.0.ttf"];
}


+ (BOOL)addSkipBackupAttributeToItemAtURLNew:(NSURL *)URL{
    NSString* path=[URL path];
    //    assert([[NSFileManager defaultManager] fileExistsAtPath:path]);
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return NO;
    }
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: @"NSURLIsExcludedFromBackupKey" error: &error];
    if(!success){
    }
    return success;
}



+ (void)saveIssueInfoToUserDefaults:(id)obj resouceName:(NSString *)res{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (obj) {
        if ([defaults objectForKey:res] == nil) {
            [defaults setObject:obj forKey:res];
            [defaults synchronize];
        } else {
            [defaults removeObjectForKey:res];
            [defaults setObject:obj forKey:res];
            [defaults synchronize];
        }
    } else {
        [defaults removeObjectForKey:res];
        [defaults synchronize];
    }
}

+ (id)getInfoFromUserDefaults:(NSString *)res {
    //get data from UserDefaults.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:res] != nil) {
        return [defaults objectForKey:res];
    } else {
        return nil;
    }
}

+ (UIImage*)zoomImage:(UIImage*)image toScale:(CGSize)resize{
    CGSize itemSize = resize;
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    UIImage* imageTmp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageTmp;
}

+ (NSString *)formatSecond:(float)second{
    int x=(int)second;
    int y=x/3600;
    int x1=x%3600;
    int miu=x1/60;
    int sec=x1%60;
    NSString *str = @"";
    if (0 < y) {
        if (y < 10) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"0%d:",y]];
        } else {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%d:",y]];
        }
    }
    if (miu < 10) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"0%d:",miu]];
    } else {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%d:",miu]];
    }
    if (sec < 10) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"0%d",sec]];
    } else {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%d",sec]];
    }
    return str;
}



+ (NSString *)UUID {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}



+ (void)showVideoAuthorizationAlertWithCompletionHandler:(void (^)(BOOL granted))completionHandler {
    AVAuthorizationStatus auth = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(auth == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (completionHandler) {
                if (granted) {
                    completionHandler(YES);
                } else {
                    completionHandler(NO);
                }
            }
         }];
    } else if(AVAuthorizationStatusAuthorized != auth){
        if (completionHandler) {
            completionHandler(NO);
        }
    } else {
        if (completionHandler) {
            completionHandler(YES);
        }
    }
}

+ (void)showAudioAuthorizationAlertWithCompletionHandler:(void (^)(BOOL granted))completionHandler {
    AVAuthorizationStatus auth = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if(auth == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (completionHandler) {
                if (granted) {
                    completionHandler(YES);
                } else {
                    completionHandler(NO);
                }
            }
        }];
    } else if(AVAuthorizationStatusAuthorized != auth){
        if (completionHandler) {
            completionHandler(NO);
        }
    } else {
        if (completionHandler) {
            completionHandler(YES);
        }
    }
}

+ (BOOL)showAlbumAuthorizationAlert {
    BOOL show = NO;
     PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if(author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied) {
        show = YES;
    }
    return show;
}


+ (CGSize)getStringSizeWith:(UIFont *)font
           andContainerSize:(CGSize)size
                  andString:(NSString *)str {
    CGSize s = CGSizeZero;
    if (!str || !str.length) {
        return s;
    }
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attri = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    CGRect rect = [str boundingRectWithSize:size
                                                  options:opts
                                               attributes:attri
                                                  context:nil];
    s = rect.size;
    return s;
}


+(NSInteger)rowsOfString:(NSString *)text withFont:(UIFont *)font withWidth:(CGFloat)width{
    if (!text || text.length == 0) {
        return 0;
    }
    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,width,MAXFLOAT));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    return lines.count;
    
}


+ (BOOL)isBangScreen{
    if ((int)((JP_SCREEN_HEIGHT/JP_SCREEN_WIDTH)*100) == 216) {
        return  YES;
    }else{
        return NO;
    }
}




+ (CGFloat)shrinkNavigationHeight{
    static CGFloat shrinkNavigationHeightUtil = - 1.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shrinkNavigationHeightUtil = (JPBangScreen ? 88.0f : 44.0f);
    });
    return shrinkNavigationHeightUtil;
}
+ (CGFloat)shrinkStatusBarHeight{
    static CGFloat shrinkStatusBarHeightUtil = - 1.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shrinkStatusBarHeightUtil = (JPBangScreen ? 44.0f : 0.0f);
    });
    return shrinkStatusBarHeightUtil;
}
+ (CGFloat)shrinkOnlyNavigationHeight{
    static CGFloat shrinkOnlyNavigationHeightUtil = - 1.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shrinkOnlyNavigationHeightUtil = (JPBangScreen ? 44.0f : 44.0f);
    });
    return shrinkOnlyNavigationHeightUtil;
}
+ (CGFloat)tabbarHeightLineHeight{
    static CGFloat tabbarHeightLineHeightUtil = - 1.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabbarHeightLineHeightUtil = (JPBangScreen ? 34.0f : 0.0f);
    });
    return tabbarHeightLineHeightUtil;
}
+ (CGFloat)normalNavigationHeightLineHeight
{
    static CGFloat normalNavigationHeightLineHeightUtil = - 1.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        normalNavigationHeightLineHeightUtil = (JPBangScreen ? 24.0f : 0.0f);
    });
    return normalNavigationHeightLineHeightUtil;
}

+ (NSString *)getDurationWithSecond:(NSInteger)seconds{
    if (seconds > 0) {
        NSInteger minute = seconds/60;
        NSInteger second = seconds%60;
        return [NSString stringWithFormat:@"%ld'%02ld\"", (long)minute, (long)second];
    }
    return @"0";
}

+ (long long)getNowTimeTimestamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    return (long)[datenow timeIntervalSince1970];
}

+ (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy-MM-dd";//指定转date得日期格式化形式
    return [dateFormatter stringFromDate:date];//2015-11-20
}


+ (NSString *)recordsInfosPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/JPSDK/local_record_info.plist"];
}

+ (NSString *)managerDicPath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/JPSDK/local_manager_Dic.plist"];
}


+ (void)addRecordInfo:(JPVideoRecordInfo *)recordInfo completion:(void (^)(void))completion
{
    NSDictionary *recordInfoDict = [recordInfo configueDict];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSMutableArray *array = [self loadLocalRecordInfo].mutableCopy;
        if ([array containsObject:recordInfo]) {
            NSInteger index = [array indexOfObject:recordInfo];
            [array removeObjectAtIndex:index];
            if (index < array.count) {
                [array insertObject:recordInfo atIndex:index];
            }else{
                [array addObject:recordInfo];
            }
        }else{
            [array addObject:recordInfo];
        }
        NSMutableArray *dictArr = [NSMutableArray array];
        for (JPVideoRecordInfo *reco in array) {
            if (reco.recordId == recordInfo.recordId) {
                [dictArr addObject:recordInfoDict];
            }else{
                [dictArr addObject:[reco configueDict]];
            }
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self recordsInfosPath]]) {
            [[NSFileManager defaultManager] removeItemAtPath:[self recordsInfosPath] error:nil];
        }
        [dictArr writeToFile:[self recordsInfosPath] atomically:YES];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

+ (void)removeRecordInfo:(JPVideoRecordInfo *)recordInfo completion:(void (^)(void))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSMutableArray *array = [self loadLocalRecordInfo].mutableCopy;
        if ([array containsObject:recordInfo]) {
            NSInteger index = [array indexOfObject:recordInfo];
            [array removeObjectAtIndex:index];
            NSMutableArray *dictArr = [NSMutableArray array];
            for (JPVideoRecordInfo *recordInfo in array) {
                [dictArr addObject:[recordInfo configueDict]];
            }
            if ([[NSFileManager defaultManager] fileExistsAtPath:[self recordsInfosPath]]) {
                [[NSFileManager defaultManager] removeItemAtPath:[self recordsInfosPath] error:nil];
            }
            [dictArr writeToFile:[self recordsInfosPath] atomically:YES];
        }
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
  });
}


+ (NSArray<JPVideoRecordInfo *> *) loadLocalRecordInfo
{
    NSArray *result = @[];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self recordsInfosPath]]) {
        NSArray *array = [NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:[self recordsInfosPath]]];
        if (array && [array isKindOfClass:[NSArray class]] && array.count > 0) {
            NSMutableArray *recors = [NSMutableArray array];
            for (NSDictionary *dict in array) {
                JPVideoRecordInfo *recordInfo = [[JPVideoRecordInfo alloc] initWithFilterManager:[[JPFilterManagers alloc] init]];
                [recordInfo updateInfoWithDict:dict];
                [recors addObject:recordInfo];
            }
            result = recors.copy;
        }
    }
    return result;
}

+ (void)loadAllRecordInfoCompletion:(void (^)(NSArray<JPVideoRecordInfo *> *))completion
{
    if (completion == nil) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSArray *result = [self loadLocalRecordInfo];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result);
        });
    });
}


+ (void)addManagerDic:(JPCompositionManager *)manager completion:(void (^)(void))completion{
    NSDictionary *managerDict = [manager configueDict];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSMutableArray *array = [self loadLocalManager].mutableCopy;
        if ([array containsObject:manager]) {
            NSInteger index = [array indexOfObject:manager];
            [array removeObjectAtIndex:index];
            if (index < array.count) {
                [array insertObject:manager atIndex:index];
            }else{
                [array addObject:manager];
            }
        }else{
            [array addObject:manager];
        }
        NSMutableArray *dictArr = [NSMutableArray array];
        for (JPCompositionManager *ma in array) {
            if ([ma.manager_id isEqualToString: manager.manager_id]) {
                [dictArr addObject:managerDict];
            }else{
                [dictArr addObject:[ma configueDict]];
            }
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self managerDicPath]]) {
            [[NSFileManager defaultManager] removeItemAtPath:[self managerDicPath] error:nil];
        }
        [dictArr writeToFile:[self managerDicPath] atomically:YES];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

+ (void)removeManagerDic:(JPCompositionManager *)manager completion:(void (^)(void))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSMutableArray *array = [self loadLocalManager].mutableCopy;
        if ([array containsObject:manager]) {
            NSInteger index = [array indexOfObject:manager];
            [array removeObjectAtIndex:index];
            NSMutableArray *dictArr = [NSMutableArray array];
            for (JPCompositionManager *ma in array) {
                [dictArr addObject:[ma configueDict]];
            }
            if ([[NSFileManager defaultManager] fileExistsAtPath:[self managerDicPath]]) {
                [[NSFileManager defaultManager] removeItemAtPath:[self managerDicPath] error:nil];
            }
            [dictArr writeToFile:[self managerDicPath] atomically:YES];
        }
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
  });
}

+ (void)removeAllManagerDicCompletion:(void (^)(void))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSMutableArray *dictArr = [NSMutableArray array];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self managerDicPath]]) {
            [[NSFileManager defaultManager] removeItemAtPath:[self managerDicPath] error:nil];
        }
        [dictArr writeToFile:[self managerDicPath] atomically:YES];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

+ (NSArray<JPCompositionManager *> *)loadLocalManager{
    NSArray *result = @[];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self managerDicPath]]) {
        NSArray *array = [NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:[self managerDicPath]]];
        if (array && [array isKindOfClass:[NSArray class]] && array.count > 0) {
            NSMutableArray *managers = [NSMutableArray array];
            for (NSDictionary *dict in array) {
                JPCompositionManager * manager = [[JPCompositionManager alloc] initWithRecordInfo:[[JPBaseVideoRecordInfo alloc] initWithFilterManager:[[JPFilterManagers alloc]init]] andStikcerArr:nil];
                [manager updateInfoWithDict:dict];
                [managers addObject:manager];
            }
            result = managers.copy;
        }
    }
    return result;
}

+ (void)loadAllManagerDicCompletion:(void (^)(NSArray<JPCompositionManager *> *))completion{
    if (completion == nil) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSArray *result = [self loadLocalManager];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result);
        });
    });
}


+ (UIViewController *)currentViewController {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *currentVC = window.rootViewController;
    while (currentVC.presentedViewController) {
        currentVC = currentVC.presentedViewController;
    }
    if ([currentVC isKindOfClass:[UITabBarController class]]) {
        currentVC = [(UITabBarController *)currentVC selectedViewController];
    }
    if ([currentVC isKindOfClass:[UINavigationController class]]) {
        currentVC = [(UINavigationController *)currentVC topViewController];
    }
    return currentVC;
}

+ (void)registNewFontWithName:(NSString *)name{
    
   

    NSString * path = [JPResourceBundlePath stringByAppendingPathComponent:name];
    NSData *dynamicFontData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
    if (!dynamicFontData) {
        return ;
    }
    CFErrorRef error;
    CGDataProviderRef providerRef = CGDataProviderCreateWithCFData((CFDataRef)dynamicFontData);
    CGFontRef font = CGFontCreateWithDataProvider(providerRef);
    if (! CTFontManagerRegisterGraphicsFont(font, &error))
    {
        //如果注册失败，则不使用
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
        return ;
    }
    CFRelease(font);
    CFRelease(providerRef);
}

@end
