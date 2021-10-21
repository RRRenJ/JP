//
//  JPUtil.h
//  jper
//
//  Created by 藩 亜玲 on 2017/3/24.
//  Copyright © 2017年 MuXiao. All rights reserved.
//
#import <UMShare/UMShare.h>
#import <Foundation/Foundation.h>
#import "MJRefreshGifHeader.h"
#import "JPAdvertisingModel.h"
#import "JPCompositionManager.h"
@interface JPUtil : NSObject

/* set view's rounding corners */
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


+ (NSString *)signStringWithDictionary:(NSDictionary *)dic;

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

+ (void)updateVideoInfoWithSharedType:(NSString *)type andVideoId:(NSString *)videoId;

+ (void)shareWebPageWithType:(UMSocialPlatformType)platformType
                   andTittle:(NSString *)tittle
                  andLinkUrl:(NSString *)url
                     andDesc:(NSString *)desc
                 andThumbImg:(UIImage *)img
                   andImgUrl:(NSString *)imgUrl
               andSharedType:(NSString *)type
                  andVideoId:(NSString *)videoId;

+ (NSString *)UUID;

+ (NSString *)getAuthUrlWithShareType:(JPShareAccountType)type;

+ (NSString *)getRulesUrlWithShareType:(JPShareAccountType)type;

+ (void)showVideoAuthorizationAlertWithCompletionHandler:(void (^)(BOOL granted))completionHandler;
+ (void)showAudioAuthorizationAlertWithCompletionHandler:(void (^)(BOOL granted))completionHandler;
+ (BOOL)showAlbumAuthorizationAlert;

+ (NSString*)decodeFromPercentEscapeString:(NSString *) string;

+ (NSString *)urlEncode:(NSString *)string;

+ (void)requestBodyAddParameterWithDic:(NSMutableDictionary *)dic;

+ (void)changeBaseVCWithAd:(BOOL)ad andAdversionModel:(JPAdvertisingModel *)model;
//切换root vc
+ (void)changeBaseVCWithTabBar;
//切换root vc
+ (void)changeBaseVCWithLogin;
//3.0登录状态改变后替换个人中心页面
+ (void)reloadTabBarChildVC;

+ (BOOL)installMessageWithPlatform:(JPShareAccountType)accountType;

+ (void)pageRecordWithVideoId:(NSString *)videoId andPosition:(NSString *)position;

+ (void)setGifHeaderWithHeader:(MJRefreshGifHeader *)header;

+ (CGSize)getStringSizeWith:(UIFont *)font andContainerSize:(CGSize)size andString:(NSString *)str;

+ (NSInteger)rowsOfString:(NSString *)text withFont:(UIFont *)font withWidth:(CGFloat)width;

+ (BOOL)addSkipBackupAttributeToItemAtURLNew:(NSURL *)URL;

+ (BOOL)showRecordGuideView;
+ (BOOL)showPackageGuideView;
+ (BOOL)showPackageVideoEditGuideView;
+ (BOOL)showPackagePhotoEditGuideView;
+ (NSString *)getRidOfWith:(NSString *)text;
+ (BOOL)isIPhoneX;
+ (void)setupStatusBarHidden:(BOOL)hidden;

+ (CGFloat)normalNavigationHeight;
+ (CGFloat)statusBarHeight;
+ (CGFloat)normalTabBarHeight;
+ (CGFloat)shrinkNavigationHeight;
+ (CGFloat)shrinkStatusBarHeight;
+ (CGFloat)shrinkOnlyNavigationHeight;
+ (CGFloat)tabbarHeightLineHeight;
+ (CGFloat)normalNavigationHeightLineHeight;
+ (CGFloat)bottomSafeAreaHeight;

+ (NSString *)getDurationWithSecond:(NSInteger)seconds;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (long long)getNowTimeTimestamp;

//退出app
+ (void)exitApplication;

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

@end
