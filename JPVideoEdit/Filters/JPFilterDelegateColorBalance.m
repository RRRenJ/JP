//
//  JPFilterDelegateColorBalance.m
//  jper
//
//  Created by FoundaoTEST on 2017/8/31.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPFilterDelegateColorBalance.h"

@interface JPFilterDelegateColorBalance ()
{
    GLint filterColorTextureUniform;
    GLint filterColorMidTextureUniform;
}

@property (nonatomic, strong) GPUImagePicture *midColorPicture;
@property (nonatomic, strong) GPUImagePicture *colorPicture;

@end

@implementation JPFilterDelegateColorBalance

- (instancetype)initWithShaderContentPaths:(NSArray<NSString *> *)shaderPaths andCurveName:(NSString *)imageName
{
    if (self = [super initWithShaderContentPaths:shaderPaths andCurveName:imageName]) {
        filterColorTextureUniform = [filterProgram uniformIndex:@"inputImageTextureColor"];
        filterColorMidTextureUniform = [filterProgram uniformIndex:@"inputImageTextureMidColor"];
        _midColorPicture = [[GPUImagePicture alloc] initWithImage:JPImageWithName(@"midRBGMap")];
        _colorPicture = [[GPUImagePicture alloc] initWithImage:JPImageWithName(@"balanceMap")];

    }
    return self;
}


- (void)bindFilterbufferToRender:(GPUImageFramebuffer *)framebuffer
{
    [super bindFilterbufferToRender:framebuffer];
    glActiveTexture(GL_TEXTURE4);
    glBindTexture(GL_TEXTURE_2D, [[_midColorPicture framebufferForOutput] texture]);
    glUniform1i(filterColorMidTextureUniform, 4);
    glActiveTexture(GL_TEXTURE5);
    glBindTexture(GL_TEXTURE_2D, [[_colorPicture framebufferForOutput] texture]);
    glUniform1i(filterColorTextureUniform, 5);
}
@end
