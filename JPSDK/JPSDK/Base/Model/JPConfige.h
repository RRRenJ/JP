//
//  JPConfige.h
//  JPSDK
//
//  Created by 任敬 on 2021/9/17.
//

#ifndef JPConfige_h
#define JPConfige_h

#define JP_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define JP_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//状态栏高度
#define JP_STATUS_HEIGHT  [UIApplication sharedApplication].statusBarFrame.size.height
//是否是刘海屏
#define JP_IS_BANGSCREEN  JP_STATUS_HEIGHT > 20.0f

#define JP_NAVIGATION_HEIGHT  (JP_STATUS_HEIGHT + 44.0f)

#define JP_BOTTOM_HEIGHT (JP_IS_BANGSCREEN ? 34.0f : 0.0f)

#define JP_TABBAR_HEIGHT (JP_BOTTOM_HEIGHT + 49.0f)


#define JPBangScreen ([JPUtil isBangScreen])
#define JPTopLiveSpaceHeight ([JPUtil isBangScreen] ? 20 : 0)
#define JPShrinkNavigationHeight ([JPUtil shrinkNavigationHeight])
#define JPShrinkStatusBarHeight ([JPUtil shrinkStatusBarHeight])
#define JPShrinkOnlyNavigationHeight ([JPUtil shrinkOnlyNavigationHeight])
#define JPTabbarHeightLineHeight ([JPUtil tabbarHeightLineHeight])
#define JPNormalNavigationHeightLineHeight ([JPUtil normalNavigationHeightLineHeight])

#define JPScreenFitFloat6(ip6s) (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? ip6s*1024/667: (ip6s/375.f*JP_SCREEN_WIDTH))



#define JP_Video_Total_Number @"JPVideoTotalNumber"
#define JP_VIDEO_MIN_DURATION CMTimeMake(3, 1)
#define JP_VIDEO_COPYRIGHT_DURATION CMTimeMake(2, 1)
#define JP_LOCAL_SOURCE_ITEM_SIZE CGSizeMake(110, 110)
#define JP_LOCAL_VIDEO_ADD_NOTI @"addLocalVideo"


#define JP_MATERIAL_FILES_FOLDER [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @"Documents", @"JPSDK"]



typedef NS_ENUM(NSInteger, JPMaterialStatus) {
    JPMaterialStatusUnknown = -1,
    JPMaterialStatusWillDownload,
    JPMaterialStatusDownloading,
    JPMaterialStatusDownLoaded
};

typedef NS_ENUM(NSInteger, JPSelectedAudioType) {
    JPSelectedAudioTypeMusic = 1,
    JPSelectedAudioTypeSoundEffect,
    JPSelectedAudioTypeRecordAudio,
};

typedef NS_ENUM(NSInteger, JPMaterialType) {
    JPMaterialTypeGraph = 1,
    JPMaterialTypeMusic = 2
};

#define FINISHSELECTEDPICTURENOTIFICATION         @"finishSelectedPictureNotification"

#endif /* JPConfige_h */
