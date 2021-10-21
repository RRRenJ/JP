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
    NSString *headerFilePath = [[NSBundle mainBundle] pathForResource:@"filterHeader" ofType:@"glsl"];
    NSString *headerStr = [NSString stringWithContentsOfFile:headerFilePath encoding:NSUTF8StringEncoding error:nil];
    NSString *shaderStr = headerStr;
    for (NSString *fileName in contentFile) {
        NSString *contentFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"glsl"];
        NSString *contentStr = [NSString stringWithContentsOfFile:contentFilePath encoding:NSUTF8StringEncoding error:nil];
        shaderStr = [NSString stringWithFormat:@"%@\n%@", shaderStr, contentStr];
    }
    NSString *footerFilePath = [[NSBundle mainBundle] pathForResource:@"filterFooter" ofType:@"glsl"];
    NSString *footerStr = [NSString stringWithContentsOfFile:footerFilePath encoding:NSUTF8StringEncoding error:nil];
    shaderStr = [NSString stringWithFormat:@"%@\n%@", shaderStr, footerStr];
    runSynchronouslyOnVideoProcessingQueue(^{
        [GPUImageContext useImageProcessingContext];
        filterProgram = [[GPUImageContext sharedImageProcessingContext] programForVertexShaderString:kGPUImageVertexShaderString fragmentShaderString:shaderStr];
        if (!filterProgram.initialized)
        {
            [self initializeAttributes];
            if (![filterProgram link])
            {
                NSString *progLog = [filterProgram programLog];
                NSLog(@"Program link log: %@", progLog);
                NSString *fragLog = [filterProgram fragmentShaderLog];
                NSLog(@"Fragment shader compile log: %@", fragLog);
                NSString *vertLog = [filterProgram vertexShaderLog];
                NSLog(@"Vertex shader compile log: %@", vertLog);
                filterProgram = nil;
                NSAssert(NO, @"Filter shader link failed");
            }
        }
        filterPositionAttribute = [filterProgram attributeIndex:@"position"];
        filterTextureCoordinateAttribute = [filterProgram attributeIndex:@"inputTextureCoordinate"];
        filterInputTextureUniform = [filterProgram uniformIndex:@"inputImageTexture"]; // This does assume a name of "inputImageTexture" for the fragment shader
        [GPUImageContext setActiveShaderProgram:filterProgram];
        glEnableVertexAttribArray(filterPositionAttribute);
        glEnableVertexAttribArray(filterTextureCoordinateAttribute);
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
