//
//  NSThread+JP.m
//  JPSDK
//
//  Created by 任敬 on 2021/9/27.
//

#import "NSThread+JP.h"

@implementation NSThread (JP)

+ (void)jp_asyncSafeInMainQueue:(void (^)(void))completion
{
    if ([self currentThread].isMainThread) {
        completion();
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    }
}

@end
