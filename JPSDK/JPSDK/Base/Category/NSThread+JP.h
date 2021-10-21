//
//  NSThread+JP.h
//  JPSDK
//
//  Created by 任敬 on 2021/9/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSThread (JP)

+ (void)jp_asyncSafeInMainQueue:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
