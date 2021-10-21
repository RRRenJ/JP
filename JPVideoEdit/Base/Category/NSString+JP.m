//
//  NSString+JP.m
//  JPSDK
//
//  Created by 任敬 on 2021/9/17.
//

#import "NSString+JP.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (JP)

- (NSString *)jp_md5{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (NSString *)jp_chineseToPinyin:(NSString *)chinese{
    if (chinese == nil || chinese.length == 0) {
        return @"";
    }
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
//    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);//去掉音标
    return pinyin;
}

@end
