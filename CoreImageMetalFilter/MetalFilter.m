//
//  MetalFilter.m
//
//  Created by Mo DeJong on 11/25/18.
//

#import "MetalFilter.h"

#import "MetalKernel.h"

@interface MetalFilter ()

@property (nonatomic, retain) CIFilter *filter1;

@end

@implementation MetalFilter

- (CIImage *)outputImage
{
  self.error = nil;
  
  NSParameterAssert(self.inputImage != nil && [self.inputImage isKindOfClass:[CIImage class]]);
  
  CIImage *inputImage = self.inputImage;
  
  CGRect imageExtent = inputImage.extent;
  
  self.filter1 = [CIFilter filterWithName:@"CILanczosScaleTransform"];
  
  [self.filter1 setValue:inputImage forKey:kCIInputImageKey];
  [self.filter1 setValue:@(512/CGRectGetHeight(imageExtent)) forKey:kCIInputScaleKey];
  CIImage* resizedImage = [self.filter1 valueForKey:kCIOutputImageKey];
  
  CGRect resizeImageExtent = resizedImage.extent;
  
  NSError *error = nil;
  
  CIImage *outputImage = [MetalKernel applyWithExtent:resizeImageExtent
                                                         inputs:@[resizedImage]
                                                      arguments:@{ @"type" : @(0) }
                                                          error:&error];
  if (error != nil) {
    self.error = error;
  }
  
  return outputImage;
}

- (NSDictionary *)customAttributes
{
  return @{
           @"type" : @{kCIAttributeDefault : @(0), kCIAttributeType : kCIAttributeTypeScalar},
           };
}

@end
