//
//  MetalFilter.m
//
//  Created by Mo DeJong on 11/25/18.
//

#import "MetalFilter.h"

#import "MetalKernel.h"

@interface MetalFilter ()

@property (nonatomic, retain) CIFilter *filter1;

@property (nonatomic, copy) NSNumber *inputWidth;

@property (nonatomic, copy) NSNumber *inputAspectRatio;

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
  
  float expectedWidth = [self.inputWidth floatValue];
  float currentHeight = imageExtent.size.height;
  float ratio = [self.inputAspectRatio floatValue];
  float aspectWidth = currentHeight * ratio;
  float scale = expectedWidth / aspectWidth;
  
  // Calculate scale to make large input size smaller but maintain same aspect ratio
  
  [self.filter1 setValue:@(1.0 / scale) forKey:kCIInputScaleKey];
  
  CIImage* resizedImage = [self.filter1 valueForKey:kCIOutputImageKey];
  
  CGRect resizeImageExtent = resizedImage.extent;
  
  NSError *error = nil;
  
  NSDictionary *arguments = @{
                              kCIInputWidthKey : self.inputWidth,
                              kCIInputAspectRatioKey : self.inputAspectRatio,
                              };
  
  CIImage *outputImage = [MetalKernel applyWithExtent:resizeImageExtent
                                                         inputs:@[resizedImage]
                                                      arguments:arguments
                                                          error:&error];
  if (error != nil) {
    self.error = error;
  }
  
  return outputImage;
}

- (NSDictionary *)customAttributes
{
  return @{
           kCIInputWidthKey : @{kCIAttributeDefault : @(0), kCIAttributeType : kCIAttributeTypeScalar},
           kCIInputAspectRatioKey : @{kCIAttributeDefault : @(0), kCIAttributeType : kCIAttributeTypeScalar},
           };
}

@end
