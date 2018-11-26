//
//  ViewController.m
//  TrivialCoreImageFilter
//
//  Created by Mo DeJong on 11/25/18.
//  Copyright © 2018 HelpURock. All rights reserved.
//

@import MetalKit;

#import "ViewController.h"

#import "MetalFilter.h"

@interface ViewController ()

@property (nonatomic, retain) IBOutlet UIImageView *ducklingImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  NSAssert(self.ducklingImageView, @"ducklingImageView");

  // Image is setup to consume 90% of the width and height
  // in the containing view with a 5% border on each side

  UIImage *inImage = self.ducklingImageView.image;
  
  {
    CGRect imageViewSize = self.ducklingImageView.frame;
    NSLog(@"imageView size %d x %d", (int) imageViewSize.size.width, (int) imageViewSize.size.height);
  }
  
  //CIContext *ciContext = [CIContext contextWithOptions:nil];
  
  // Convert from color input image to old school BW
  
  if ((false)) {
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
    
    CIImage *inCIImage = [[CIImage alloc] initWithImage:inImage];
    
    [filter setValue:inCIImage forKeyPath:kCIInputImageKey];
    
    CIImage *outCIImage = filter.outputImage;
    UIImage *uiImgFromCIImage = [UIImage imageWithCIImage:outCIImage];
    
    self.ducklingImageView.image = uiImgFromCIImage;
  }

  if (true) {
    CIFilter *filter = [[MetalFilter alloc] init];
    
    CIImage *inCIImage = [[CIImage alloc] initWithImage:inImage];
    
    {
      CGRect imageExtent = inCIImage.extent;
      NSLog(@"inCIImage extent %d x %d", (int) imageExtent.size.width, (int) imageExtent.size.height);
    }

    [filter setValue:inCIImage forKeyPath:kCIInputImageKey];
    
    // Calculate scale size so that large input image is scaled down to a size that
    // is the same size as the image view frame
    
    {
      CGFloat scale = [UIScreen mainScreen].scale;
      CGSize imageViewSize = self.ducklingImageView.frame.size;
      imageViewSize = CGSizeMake(imageViewSize.width * scale, imageViewSize.height * scale);
      
      {
        NSLog(@"expected resize to %d x %d", (int) imageViewSize.width, (int) imageViewSize.height);
      }
      
      CGFloat ratio = imageViewSize.width / imageViewSize.height;
      
      [filter setValue:@(imageViewSize.width) forKeyPath:kCIInputWidthKey];
      [filter setValue:@(ratio) forKeyPath:kCIInputAspectRatioKey];
    }
    
    CIImage *outCIImage = filter.outputImage;
    UIImage *uiImgFromCIImage = [UIImage imageWithCIImage:outCIImage];
    
    self.ducklingImageView.image = uiImgFromCIImage;
  }

}

@end
