//
//  JPFilterDelegateNormal.h
//  jper
//
//  Created by FoundaoTEST on 2017/8/31.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPFilterDelegateNormal : NSObject<JPGeneralFilterDelegate>
{
    GLProgram *filterProgram;
}
- (instancetype)initWithShaderContentPaths:(NSArray<NSString *> *)shaderPaths;

- (void)useProgramAsCurrent;
- (void)setVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;
- (void)bindFilterbufferToRender:(GPUImageFramebuffer *)framebuffer;

@end
