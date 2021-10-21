//
//  NSString+JP.h
//  JPSDK
//
//  Created by 任敬 on 2021/9/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (JP)

- (NSString *)jp_md5;

+ (NSString *)jp_chineseToPinyin:(NSString *)chinese;


@end

NS_ASSUME_NONNULL_END
