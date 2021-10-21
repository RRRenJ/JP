//
//  JPFilterDelegateOnlyCurve.m
//  jper
//
//  Created by FoundaoTEST on 2017/8/31.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPFilterDelegateOnlyCurve.h"

@interface JPFilterDelegateOnlyCurve ()

{
    GLint filterRGBTextureUniform;
}
@property (nonatomic, strong) GPUImagePicture *rgbPicture;
@end

@implementation JPFilterDelegateOnlyCurve

- (instancetype)initWithShaderContentPaths:(NSArray<NSString *> *)shaderPaths andCurveName:(NSString *)imageName
{
    if (self = [super initWithShaderContentPaths:shaderPaths]) {
        self.rgbPicture = [[GPUImagePicture alloc] initWithImage:JPImageWithName(imageName)];
        filterRGBTextureUniform = [filterProgram uniformIndex:@"inputImageTextureRGB"];
    }
    return self;
}


- (void)bindFilterbufferToRender:(GPUImageFramebuffer *)framebuffer
{
    [super bindFilterbufferToRender:framebuffer];
    glActiveTexture(GL_TEXTURE3);
    glBindTexture(GL_TEXTURE_2D, [[_rgbPicture framebufferForOutput] texture]);
    glUniform1i(filterRGBTextureUniform, 3);
}


@end
