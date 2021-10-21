//
//  JPManager.m
//  JPSDK
//
//  Created by 任敬 on 2021/10/21.
//

#import "JPManager.h"

@implementation JPManager

+ (void)loadConfige{
    [JPUtil createJperFolder];
    [JPUtil createJperFolderInDocument];
    [JPUtil loadCustomFont];
}

+ (void)startVideoEdit{
    
}

+ (void)reeditVideo:(JPVideoRecordInfo *)info{
    
}

+ (void)getLocalVideoDraft:(void (^)(NSArray<JPVideoRecordInfo *> * _Nonnull))completion{
    [JPUtil loadAllRecordInfoCompletion:completion];
}

+ (void)removeDraftWithVideo:(JPVideoRecordInfo *)info completion:(void (^)(void))completion{
    [JPUtil removeRecordInfo:info completion:completion];
}


@end
