//
//  ViewController.m
//  TrivialCoreImageFilter
//
//  Created by Mo DeJong on 11/25/18.
//  Copyright © 2018 HelpURock. All rights reserved.
//

#import "ViewController.h"

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
  
  if (true) {
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
    
    CIImage *inCIImage = [[CIImage alloc] initWithImage:inImage];
    
    [filter setValue:inCIImage forKeyPath:kCIInputImageKey];
    
    CIImage *outCIImage = filter.outputImage;
    UIImage *uiImgFromCIImage = [UIImage imageWithCIImage:outCIImage];
    
    self.ducklingImageView.image = uiImgFromCIImage;
  }
  
}

@end
