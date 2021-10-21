//
//  JPUtil.m
//  jper
//
//  Created by 藩 亜玲 on 2017/3/24.
//  Copyright © 2017年 MuXiao. All rights reserved.
//
#import "JPUtil.h"
#import "NSString+MD5.h"
#import "JPHotListViewController.h"
#import "JPNewCameraViewController.h"
#import "JPBaseTabBarViewController.h"
#import "PKLoginViewController.h"
#import <MPShareSDK/MPShareSDK.h>
#import "JPSession.h"
#import "AFNetworkReachabilityManager.h"
#import "JPVideoClipViewController.h"
#import "JPAdController.h"
#import "PKProvideLoginController.h"
#import <CoreText/CoreText.h>
@implementation JPUtil

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
            JPLog(@"Create directory error: %@", error);
            return NO;
        }
    }
    return YES;
}

+ (BOOL)createJperFolderInDocument{
    if (![[NSFileManager defaultManager] fileExistsAtPath:PK_MATERIAL_FILES_FOLDER]) {
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:PK_MATERIAL_FILES_FOLDER
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error]){
            JPLog(@"Create directory error: %@", error);
            return NO;
        }
    }
    return YES;
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

+ (NSString *)signStringWithDictionary:(NSDictionary *)dic
{
    NSMutableString *bodyStr = [NSMutableString string];
    NSArray *keys = dic.allKeys;
    NSArray *sortKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *key1 = obj1;
        NSString *key2 = obj2;
        return [key1 compare:key2];
    }];
    for (NSString *key in sortKeys) {
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@",key, dic[key]];
        if (bodyStr.length == 0) {
            [bodyStr appendString:keyValue];
        }else{
            [bodyStr appendFormat:@"&%@", keyValue];
        }
    }
    NSString *uppercaseString = [bodyStr uppercaseString];
    NSString *tempStr = [NSString stringWithFormat:@"%@%@", uppercaseString, @"JPER_API"];
    NSString *firstMD5 = [tempStr md5];
    NSString *thirtyStr = [firstMD5 substringWithRange:NSMakeRange(0, 30)];
    NSString *sign = [thirtyStr md5];
    return sign;
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

+ (void)updateVideoInfoWithSharedType:(NSString *)type andVideoId:(NSString *)videoId{
    NSString *url = [NSString stringWithFormat:@"%@user/update-video-info",API_HOST];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic sgrSetObject:type forKey:@"share_to"];
    [dic sgrSetObject:videoId forKey:@"uuid"];
    if ([JPUserInfo shareInstance].isLogin && [JPUserInfo shareInstance].token) {
        [dic setObject:[JPUserInfo shareInstance].token forKey:@"token"];
    }
    [JPService requestWithURLString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:dic type:JPHttpRequestTypePost success:^(JPResultBase *response){
        if (response.code && 0 == [response.code intValue]) {
            
        } else {
            
        }
        
    }failure:^(NSError *error){
        
    } withErrorMsg:nil];
}

+ (void)shareWebPageWithType:(UMSocialPlatformType)platformType
                   andTittle:(NSString *)tittle
                  andLinkUrl:(NSString *)url
                     andDesc:(NSString *)desc
                 andThumbImg:(UIImage *)img
                   andImgUrl:(NSString *)imgUrl
               andSharedType:(NSString *)type
                  andVideoId:(NSString *)videoId{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject;
    NSString *description;
    if ([desc length] > 40) {
        description = [NSString stringWithFormat:@"%@...",[desc substringToIndex:39]];
    } else {
        description = desc;
    }
    if (img) {
        //创建分享消息对象
        //创建网页内容对象
        shareObject = [UMShareWebpageObject shareObjectWithTitle:tittle descr:description thumImage:img];

    } else if (imgUrl){
        shareObject = [UMShareWebpageObject shareObjectWithTitle:tittle descr:description thumImage:imgUrl];
    }
    shareObject.webpageUrl = url;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            [JPUtil updateVideoInfoWithSharedType:type andVideoId:videoId];
        }
    }];
}

+ (NSString *)UUID {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

+ (NSString*) decodeFromPercentEscapeString:(NSString *) string {
    return (__bridge NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                         (__bridge CFStringRef) string,
                                                                                         CFSTR(""),
                                                                                         kCFStringEncodingUTF8);
}

+ (NSString *)urlEncode:(NSString *)string {
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                     
                                                                     (__bridge CFStringRef)string,
                                                                     NULL,CFSTR("!*'();:@&=+$,/?%#[]"),                                                              CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

+ (NSString *)getAuthUrlWithShareType:(JPShareAccountType)type {
    NSString *url = @"";
    switch (type) {
        case JPShareAccountTypeTouTiao:
            url = [NSString stringWithFormat:@"%@?response_type=code&auth_only=1&client_key=%@&redirect_uri=%@&state=febac09284cba",TOU_TIAO_AUTH_URL,TOU_TIAO_CLIENT_KEY,TOU_TIAO_REDIRECT_URL];
            break;
        case JPShareAccountTypeWeiBo:
            url = [NSString stringWithFormat:@"%@client_id=%@&response_type=code&redirect_uri=%@",WEI_BO_AUTH_URL,WEI_BO_AUTH_APP_KEY,TOU_TIAO_REDIRECT_URL];
            break;
        case JPShareAccountTypeAiQiYi:
            url = [[NSString stringWithFormat:@"%@?token=%@",AI_QI_YI_AUTH_URL,[JPUserInfo shareInstance].token] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            break;
        default:
            break;
    }
    return url;
}

+ (NSString *)getRulesUrlWithShareType:(JPShareAccountType)type {
    NSString *url = @"";
    switch (type) {
        case JPShareAccountTypeTouTiao:
            url = @"http://cdn-jper.foundao.com/jper_h5/tt_bound.html";
            break;
        case JPShareAccountTypeWeiBo:
            url = @"http://cdn-jper.foundao.com/jper_h5/wb_bound.html";
            break;
        case JPShareAccountTypeAiQiYi:
            url = @"http://cdn-jper.foundao.com/jper_h5/aqy_bound.html";
            break;
        default:
            break;
    }
    return url;
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
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if(author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
        show = YES;
    }
    return show;
}

+ (void)requestBodyAddParameterWithDic:(NSMutableDictionary *)dic
{
    [dic setObject:[NSNumber numberWithInteger:3] forKey:@"channel_id"];
    [dic setObject:[NSNumber numberWithInteger:1] forKey:@"platform"];
    [dic setObject:[NSNumber numberWithInteger:1] forKey:@"app_type"];
    [dic sgrSetObject:JP_APP_VERSION forKey:@"app_version"];

}

///登录成功后 window的root改为tabbarvc
+ (void)changeBaseVCWithTabBar {
    [JPUtil setupStatusBarHidden:NO];
    if ([PKThreeLoginManager manager].isThreeLogin && [JPUserInfo shareInstance].isLogin) {
        PKProvideLoginController *Vc = [[PKProvideLoginController alloc]init];
        [JPAppDelegate shareAppdelegate].window.rootViewController = Vc;
    }else{
        JPBaseTabBarViewController *tabBarVC = [[JPBaseTabBarViewController alloc] init];
        [JPAppDelegate shareAppdelegate].window.rootViewController = tabBarVC;
        [JPAppDelegate shareAppdelegate].window.backgroundColor = [UIColor whiteColor];
        [[JPAppDelegate shareAppdelegate].window makeKeyAndVisible];
    }
    
}

///退出登录后 window的root改为loginvc
+ (void)changeBaseVCWithLogin {
    PKLoginViewController *vc = [[PKLoginViewController alloc] init];
    vc.isRoot = YES;
    JPBaseNavigationViewController *nav = [[JPBaseNavigationViewController alloc] initWithRootViewController:vc];
    [JPAppDelegate shareAppdelegate].window.rootViewController = nav;
    [JPAppDelegate shareAppdelegate].window.backgroundColor = [UIColor whiteColor];
    [[JPAppDelegate shareAppdelegate].window makeKeyAndVisible];
}

+ (void)reloadTabBarChildVC{
    [[JPAppDelegate shareAppdelegate].baseTabBarController reloadChildVC];
}


+ (BOOL)installMessageWithPlatform:(JPShareAccountType)accountType
{
    if (accountType == JPShareAccountTypeWeiBo && ![[UIApplication sharedApplication] canOpenURL:[NSURL  URLWithString:@"sinaweibo://"]]) {
        [[JPAppDelegate shareAppdelegate] showAlertViewWithTitle:@"请先安装微博再进行分享"];
        return NO;
    }else if((accountType == JPShareAccountTypeWeiXin || accountType == JPShareAccountTypePengYouQuan) && ![[UIApplication sharedApplication] canOpenURL:[NSURL  URLWithString:@"weixin://"]]){
        [[JPAppDelegate shareAppdelegate] showAlertViewWithTitle:@"请先安装微信再进行分享"];
        return NO;
    }
    return YES;
}

+ (void)pageRecordWithVideoId:(NSString *)videoId andPosition:(NSString *)position {
    NSString *url = [NSString stringWithFormat:@"%@case/page-case",API_HOST];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([JPUserInfo shareInstance].isLogin && [JPUserInfo shareInstance].token) {
        [dic sgrSetObject:[JPUserInfo shareInstance].token forKey:@"token"];
    }
    if (videoId) {
        [dic sgrSetObject:videoId forKey:@"uuid"];
    }
    if (position) {
        [dic sgrSetObject:position forKey:@"position"];
    }
    [dic sgrSetObject:[JPSession sharedInstance].positionStr forKey:@"location"];
    [dic sgrSetObject:[JPSession sharedInstance].locationCoordinateStr forKey:@"long_lat"];
    [JPUtil requestBodyAddParameterWithDic:dic];
    [JPService requestWithURLString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:dic type:JPHttpRequestTypePost success:^(JPResultBase *response){
        if (response.code && 0 == [response.code intValue]) {
            
        } else {
            
        }
        
    }failure:^(NSError *error){
        
    } withErrorMsg:nil];
}

+ (void)setGifHeaderWithHeader:(MJRefreshGifHeader *)header {
    NSMutableArray *pullingArr = [NSMutableArray array];
    [pullingArr sgrAddObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"drop-down00000" ofType:@".png"]]];
    NSMutableArray *refreshingArr = [NSMutableArray array];
    for (int i = 0; i < 17;i++) {
        NSString *name;

        if (i < 10) {
            name = [NSString stringWithFormat:@"drop-down0000%d",i];
        } else {
            name = [NSString stringWithFormat:@"drop-down000%d",i];
        }
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@".png"]];
        [refreshingArr sgrAddObject:img];
        
    }
    
    NSMutableArray *willRefreshingArr = [NSMutableArray array];
    for (int i = 17; i < 36;i++) {
        NSString *name = [NSString stringWithFormat:@"drop-down000%d",i];
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@".png"]];
        [willRefreshingArr sgrAddObject:img];
        
    }
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setImages:pullingArr forState:MJRefreshStateIdle];
    [header setImages:refreshingArr forState:MJRefreshStatePulling];
    [header setImages:willRefreshingArr forState:MJRefreshStateRefreshing];
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


+ (BOOL)showRecordGuideView {
    if (![JPUtil getInfoFromUserDefaults:kRecordOfVideoSpeedGuideStep]) {
        return YES;
    }
    if (![JPUtil getInfoFromUserDefaults:kRecordOfCamaraFlipGuideStep]) {
        return YES;
    }
    if (![JPUtil getInfoFromUserDefaults:kRecordOfFilterSelectedGuideStep]) {
        return YES;
    }
    if (![JPUtil getInfoFromUserDefaults:kRecordOfFlashLightSelectedGuideStep]) {
        return YES;
    }
    if (![JPUtil getInfoFromUserDefaults:kRecordOfVideoFrameGuideStep]) {
        return YES;
    }
    return NO;
}

+ (BOOL)showPackageGuideView {
    if (![JPUtil getInfoFromUserDefaults:kPackageOfFilterSelectedGuideStep]) {
        return YES;
    }
    if (![JPUtil getInfoFromUserDefaults:kPackageOfAddPatternGuideStep]) {
        return YES;
    }
    if (![JPUtil getInfoFromUserDefaults:kPackageOfAddMusicGuideStep]) {
        return YES;
    }
    return NO;
}

+ (BOOL)showPackageVideoEditGuideView {
    if (![JPUtil getInfoFromUserDefaults:kPackageOfVideoSpeedGuideStep]) {
        return YES;
    }
    if (![JPUtil getInfoFromUserDefaults:kPackageOfVideoTranverseGuideStep]) {
        return YES;
    }
    if (![JPUtil getInfoFromUserDefaults:kPackageOfvideoTrimGuideStep]) {
        return YES;
    }
    if (![JPUtil getInfoFromUserDefaults:kPackageOfVideoDeleteGuideStep]) {
        return YES;
    }
    return NO;
}

+ (BOOL)showPackagePhotoEditGuideView {
    if (![JPUtil getInfoFromUserDefaults:kPackageOfPhotoDeleteGuideStep]) {
        return YES;
    }
    if (![JPUtil getInfoFromUserDefaults:kPackageOfEnlargePhotoGuideStep]) {
        return YES;
    }
    if (![JPUtil getInfoFromUserDefaults:kPackageOfReducePhotoGuideStep]) {
        return YES;
    }
    return NO;
}

+ (NSString *)getRidOfWith:(NSString *)text {
    NSString * content = text;
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return content;
}

+ (BOOL)isIPhoneX
{
    if ((int)((SCREEN_HEIGHT/SCREEN_WIDTH)*100) == 216) {
        return  YES;
    }else{
        return NO;
    }
   
}

+ (void)setupStatusBarHidden:(BOOL)hidden
{
    if ([self isIPhoneX]) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:hidden];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}


+ (CGFloat)normalNavigationHeight
{
    static CGFloat normalNavigationHeightUtil = - 1.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        normalNavigationHeightUtil = (KISIPhoneX ? 88.0f : 64.0f);
    });
    return normalNavigationHeightUtil;
}
+ (CGFloat)statusBarHeight
{
    static CGFloat statusBarHeightUtil = - 1.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        statusBarHeightUtil = (KISIPhoneX ? 44.0f : 20.0f);
    });
    return statusBarHeightUtil;
}
+ (CGFloat)normalTabBarHeight;
{
    static CGFloat normalTabBarHeightUtil = - 1.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        normalTabBarHeightUtil = (KISIPhoneX ? 83.0f : 49.0f);
    });
    return normalTabBarHeightUtil;
}
+ (CGFloat)shrinkNavigationHeight
{
    static CGFloat shrinkNavigationHeightUtil = - 1.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shrinkNavigationHeightUtil = (KISIPhoneX ? 88.0f : 44.0f);
    });
    return shrinkNavigationHeightUtil;
}
+ (CGFloat)shrinkStatusBarHeight
{
    static CGFloat shrinkStatusBarHeightUtil = - 1.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shrinkStatusBarHeightUtil = (KISIPhoneX ? 44.0f : 0.0f);
    });
    return shrinkStatusBarHeightUtil;
}
+ (CGFloat)shrinkOnlyNavigationHeight
{
    static CGFloat shrinkOnlyNavigationHeightUtil = - 1.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shrinkOnlyNavigationHeightUtil = (KISIPhoneX ? 44.0f : 44.0f);
    });
    return shrinkOnlyNavigationHeightUtil;
}
+ (CGFloat)tabbarHeightLineHeight
{
    static CGFloat tabbarHeightLineHeightUtil = - 1.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabbarHeightLineHeightUtil = (KISIPhoneX ? 34.0f : 0.0f);
    });
    return tabbarHeightLineHeightUtil;
}
+ (CGFloat)normalNavigationHeightLineHeight
{
    static CGFloat normalNavigationHeightLineHeightUtil = - 1.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        normalNavigationHeightLineHeightUtil = (KISIPhoneX ? 24.0f : 0.0f);
    });
    return normalNavigationHeightLineHeightUtil;
}
+ (CGFloat)bottomSafeAreaHeight
{
    static CGFloat bottomSafeAreaHeight = - 1.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bottomSafeAreaHeight = (KISIPhoneX ? 34.0f : 0.0f);
    });
    return bottomSafeAreaHeight;
}

+ (NSString *)getDurationWithSecond:(NSInteger)seconds {
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
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/paike/local_record_info.plist"];
}

+ (NSString *)managerDicPath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/paike/local_manager_Dic.plist"];
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

+ (void)exitApplication {
    
    UIWindow *window = [JPAppDelegate shareAppdelegate].window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(window.bounds.size.width/2, window.bounds.size.height/2, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
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

@end
