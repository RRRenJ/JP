//
//  UIImage+JP.h
//  JPSDK
//
//  Created by 任敬 on 2021/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (JP)

+ (UIImage *)jp_getImageWithColor:(UIColor *)color;
+ (UIImage*)jp_getVideoPreViewImageWithUrl:(NSURL *)url;
+ (UIImage *)jp_fixOrientation:(UIImage *)srcImg;
+ (UIImage *)jp_croppedImage:(UIImage *)image bounds:(CGRect)bounds;
+ (CVPixelBufferRef )jp_pixelBufferFromCGImage:(CGImageRef)image;


- (UIImage *)jp_fixOrientation;
- (UIImage *)jp_imageToScale:(float)scaleSize;
- (UIImage *)jp_fd_croppedImage:(CGRect)bounds;
- (UIImage*)jp_rotate:(UIImageOrientation)orient;

@end

NS_ASSUME_NONNULL_END
