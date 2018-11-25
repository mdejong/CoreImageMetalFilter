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
    
    [filter setValue:inCIImage forKeyPath:kCIInputImageKey];
    
    CIImage *outCIImage = filter.outputImage;
    UIImage *uiImgFromCIImage = [UIImage imageWithCIImage:outCIImage];
    
    self.ducklingImageView.image = uiImgFromCIImage;
  }

}

@end
