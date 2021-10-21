//
//  JPManager.h
//  JPSDK
//
//  Created by 任敬 on 2021/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPManager : NSObject


+ (void)loadConfige;

+ (void)startVideoEdit;

+ (void)reeditVideo:(JPVideoRecordInfo *)info;

+ (void)getLocalVideoDraft:(void(^)(NSArray <JPVideoRecordInfo *>*videoArray))completion;

+ (void)removeDraftWithVideo:(JPVideoRecordInfo *)info completion:(void(^)(void))completion;




@end

NS_ASSUME_NONNULL_END
