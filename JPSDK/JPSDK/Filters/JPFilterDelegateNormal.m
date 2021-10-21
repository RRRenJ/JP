//
//  JPFilterDelegateNormal.m
//  jper
//
//  Created by FoundaoTEST on 2017/8/31.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPFilterDelegateNormal.h"

@interface JPFilterDelegateNormal ()
{
    GLint filterPositionAttribute, filterTextureCoordinateAttribute;
    GLint filterInputTextureUniform;
}
@end

@implementation JPFilterDelegateNormal

- (instancetype)init
{
    if (self = [super init]) {
        [self complieShaderProgramWithContentFile:@[@"filterNormal"]];
    }
    return self;
}


- (instancetype)initWithShaderContentPaths:(NSArray<NSString *> *)shaderPaths
{
    if (self = [super init]) {
        [self complieShaderProgramWithContentFile:shaderPaths];
    }
    return self;
}

- (void)complieShaderProgramWithContentFile:(NSArray<NSString *> *)contentFile
{
    NSString *headerFilePath = [JP_Resource_bundle pathForResource:@"filterHeader" ofType:@"glsl"];
    NSString *headerStr = [NSString stringWithContentsOfFile:headerFilePath encoding:NSUTF8StringEncoding error:nil];
    NSString *shaderStr = headerStr;
    for (NSString *fileName in contentFile) {
        NSString *contentFilePath = [JP_Resource_bundle pathForResource:fileName ofType:@"glsl"];
        NSString *contentStr = [NSString stringWithContentsOfFile:contentFilePath encoding:NSUTF8StringEncoding error:nil];
        shaderStr = [NSString stringWithFormat:@"%@\n%@", shaderStr, contentStr];
    }
    NSString *footerFilePath = [JP_Resource_bundle pathForResource:@"filterFooter" ofType:@"glsl"];
    NSString *footerStr = [NSString stringWithContentsOfFile:footerFilePath encoding:NSUTF8StringEncoding error:nil];
    shaderStr = [NSString stringWithFormat:@"%@\n%@", shaderStr, footerStr];
    runSynchronouslyOnVideoProcessingQueue(^{
        [GPUImageContext useImageProcessingContext];
        self->filterProgram = [[GPUImageContext sharedImageProcessingContext] programForVertexShaderString:kGPUImageVertexShaderString fragmentShaderString:shaderStr];
        if (!self->filterProgram.initialized)
        {
            [self initializeAttributes];
            if (![self->filterProgram link])
            {
                NSString *progLog = [self->filterProgram programLog];
                NSLog(@"Program link log: %@", progLog);
                NSString *fragLog = [self->filterProgram fragmentShaderLog];
                NSLog(@"Fragment shader compile log: %@", fragLog);
                NSString *vertLog = [self->filterProgram vertexShaderLog];
                NSLog(@"Vertex shader compile log: %@", vertLog);
                self->filterProgram = nil;
                NSAssert(NO, @"Filter shader link failed");
            }
        }
        self->filterPositionAttribute = [self->filterProgram attributeIndex:@"position"];
        self->filterTextureCoordinateAttribute = [self->filterProgram attributeIndex:@"inputTextureCoordinate"];
        self->filterInputTextureUniform = [self->filterProgram uniformIndex:@"inputImageTexture"]; // This does assume a name of "inputImageTexture" for the fragment shader
        [GPUImageContext setActiveShaderProgram:self->filterProgram];
        glEnableVertexAttribArray(self->filterPositionAttribute);
        glEnableVertexAttribArray(self->filterTextureCoordinateAttribute);
    });
}

- (void)useProgramAsCurrent
{
    [GPUImageContext setActiveShaderProgram:filterProgram];
}

- (void)bindFilterbufferToRender:(GPUImageFramebuffer *)framebuffer
{
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, [framebuffer texture]);
    glUniform1i(filterInputTextureUniform, 2);
}

- (void)setVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates
{
    glVertexAttribPointer(filterPositionAttribute, 2, GL_FLOAT, 0, 0, vertices);
    glVertexAttribPointer(filterTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, textureCoordinates);
}

- (void)initializeAttributes;
{
    [filterProgram addAttribute:@"position"];
    [filterProgram addAttribute:@"inputTextureCoordinate"];
}
@end
