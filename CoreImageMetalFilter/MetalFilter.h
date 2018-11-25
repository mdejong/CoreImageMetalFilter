//
//  MetalFilter.h
//
//  Created by Mo DeJong on 11/25/18.
//

#import <Foundation/Foundation.h>

#import <CoreImage/CoreImage.h>

@interface MetalFilter : CIFilter

@property (nonatomic, retain) CIImage *inputImage;

// If there is an error while processing the filter, this value is
// set to non-nil. Otherwise it is set to nil.

@property (nonatomic, retain) NSError *error;

@end
