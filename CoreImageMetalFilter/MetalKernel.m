//
//  MetalKernel.m
//
//  Created by Mo DeJong on 11/25/18.
//

#import "MetalKernel.h"

#import <Metal/Metal.h>

@interface MetalKernel ()

@property (nonatomic, retain) id<MTLDevice> device;

@property (nonatomic, retain) id<MTLComputePipelineState> computePipelineState;

@end

@implementation MetalKernel

- (BOOL) setupMetal
{
  NSError *error = NULL;
  
  self.device = MTLCreateSystemDefaultDevice();
  
  // Load all the shader files with a .metal file extension in the project
  id<MTLLibrary> defaultLibrary = [self.device newDefaultLibrary];
  
  // Load the kernel function from the library
  id<MTLFunction> kernelFunction = [defaultLibrary newFunctionWithName:@"grayscaleKernel"];
  
  // Create a compute pipeline state
  self.computePipelineState = [self.device newComputePipelineStateWithFunction:kernelFunction
                                                                         error:&error];
  
  if(!self.computePipelineState)
  {
    // Compute pipeline State creation could fail if kernelFunction failed to load from the
    //   library.  If the Metal API validation is enabled, we automatically be given more
    //   information about what went wrong.  (Metal API validation is enabled by default
    //   when a debug build is run from Xcode)
    NSLog(@"Failed to create compute pipeline state, error %@", error);
    return FALSE;
  }
  
  return TRUE;
}

+ (BOOL)processWithInputs:(NSArray<id<CIImageProcessorInput>> *)inputs arguments:(NSDictionary<NSString *,id> *)arguments output:(id<CIImageProcessorOutput>)output error:(NSError * _Nullable *)error
{
  // Create an instance of MetalKernel
  
  MetalKernel *metalKernel = [[MetalKernel alloc] init];
  
  BOOL worked = [metalKernel setupMetal];
  
  if (!worked) {
    // FIXME: set error in caller ?
    return NO;
  }
  
  id<CIImageProcessorInput> input = inputs.firstObject;
  
  id<MTLCommandBuffer> commandBuffer = output.metalCommandBuffer;
  commandBuffer.label = @"MetalKernel";
  
  id<MTLTexture> inputTexture = input.metalTexture;
  id<MTLTexture> outputTexture = output.metalTexture;
  
  // Setup mapping from pixels to threadgroups
  
  const int blockDim = 8;
  
  int numBlocksInWidth = (int)inputTexture.width / blockDim;
  if ((inputTexture.width % blockDim) != 0) {
    numBlocksInWidth += 1;
  }
  
  int numBlocksInHeight = (int)inputTexture.height / blockDim;
  if ((inputTexture.height % blockDim) != 0) {
    numBlocksInHeight += 1;
  }
  
  MTLSize threadsPerThreadgroup = MTLSizeMake(blockDim, blockDim, 1);
  MTLSize threadsPerGrid = MTLSizeMake(numBlocksInWidth, numBlocksInHeight, 1);
  
  id<MTLComputeCommandEncoder> computeEncoder;
  
  computeEncoder = [commandBuffer computeCommandEncoder];
  
  [computeEncoder setComputePipelineState:metalKernel.computePipelineState];
  
  [computeEncoder setTexture:inputTexture atIndex:0];
  [computeEncoder setTexture:outputTexture atIndex:1];
  
  [computeEncoder dispatchThreadgroups:threadsPerGrid threadsPerThreadgroup:threadsPerThreadgroup];
  
  [computeEncoder endEncoding];
  
  return YES;
}

@end
