//
//  JPUtil.h
//  jper
//
//  Created by 藩 亜玲 on 2017/3/24.
//  Copyright © 2017年 MuXiao. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "JPCompositionManager.h"

#define JPResourceBundle [JPUtil bundleWithName:@"JPResource"]

#define JPResourceBundlePath JPResourceBundle.bundlePath

#define JPImageWithName(file)                 [JPUtil imageNamed:file withBundle:JPResourceBundle]


@interface JPUtil : NSObject

+ (NSBundle *)bundleWithName:(NSString *)name;

+ (UIImage *)imageNamed:(NSString *)name withBundle:(NSBundle *)bundle;

+ (void)setViewRadius:(UIView *)view
    byRoundingCorners:(UIRectCorner)corners
          cornerRadii:(CGSize)cornerRadii;

/**
 *  创建自定义按钮
 *  @param  tittle 按钮显示文字
 *  @param  image 按钮图片
 *  @param  frame 按钮frame
 *  @param  target 目标对象
 *  @param  action 执行动作
 */
+ (UIButton *)createCustomButtonWithTittle:(NSString *)tittle
                                 withImage:(UIImage *)image
                                 withFrame:(CGRect)frame
                                    target:(id)target
                                    action:(SEL)action;

+ (BOOL)createJperFolder;

+ (BOOL)createJperFolderInDocument;

+ (void)loadCustomFont;


//+ (NSString *)signStringWithDictionary:(NSDictionary *)dic;

/**
 *  保存数据到user defaults
 *  @param  obj 数据
 *  @param  res 数据对应的key
 */
+ (void)saveIssueInfoToUserDefaults:(id)obj resouceName:(NSString *)res;

/**
 *  从user defaults取数据
 *  @param  res 数据对应的key
 */
+ (id)getInfoFromUserDefaults:(NSString *)res;

+ (UIImage*)zoomImage:(UIImage*)image toScale:(CGSize)resize;

+ (NSString *)formatSecond:(float)second;

+ (NSString *)UUID;


+ (void)showVideoAuthorizationAlertWithCompletionHandler:(void (^)(BOOL granted))completionHandler;
+ (void)showAudioAuthorizationAlertWithCompletionHandler:(void (^)(BOOL granted))completionHandler;
+ (BOOL)showAlbumAuthorizationAlert;

+ (CGSize)getStringSizeWith:(UIFont *)font andContainerSize:(CGSize)size andString:(NSString *)str;

+ (NSInteger)rowsOfString:(NSString *)text withFont:(UIFont *)font withWidth:(CGFloat)width;


+ (BOOL)isBangScreen;

+ (CGFloat)shrinkNavigationHeight;
+ (CGFloat)shrinkStatusBarHeight;
+ (CGFloat)shrinkOnlyNavigationHeight;
+ (CGFloat)tabbarHeightLineHeight;
+ (CGFloat)normalNavigationHeightLineHeight;

+ (NSString *)getDurationWithSecond:(NSInteger)seconds;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (long long)getNowTimeTimestamp;


// 草稿箱功能api
//关于草稿箱功能的api提供
//所有操作都是异步的
+ (void)addRecordInfo:(JPVideoRecordInfo *)recordInfo completion:(void(^)(void))completion;  //新增和更新某个视频编辑信息统一调用这个
+ (void)removeRecordInfo:(JPVideoRecordInfo *)recordInfo completion:(void(^)(void))completion;

+ (void)loadAllRecordInfoCompletion:(void(^)(NSArray<JPVideoRecordInfo *> *result))completion;

///仅用于对manager的标签信息获取，
+ (void)addManagerDic:(JPCompositionManager *)manager completion:(void (^)(void))completion;
+ (void)removeManagerDic:(JPCompositionManager *)manager completion:(void (^)(void))completion;
+ (void)loadAllManagerDicCompletion:(void (^)(NSArray<JPCompositionManager *> *result))completion;
+ (void)removeAllManagerDicCompletion:(void (^)(void))completion;

+ (UIViewController *)currentViewController;

+ (void)registNewFontWithName:(NSString *)name;

@end
