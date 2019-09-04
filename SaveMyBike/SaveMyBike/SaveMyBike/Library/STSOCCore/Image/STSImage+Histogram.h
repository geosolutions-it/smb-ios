//
//  STSImage+Histogram.h
//
//  Created by Szymon Tomasz Stefanek on 3/22/13.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSImage.h"
#import "STSIRect.h"
#import "STSImageHistogram.h"

@interface STSImage(Histogram)

- (STSImageHistogram *)computeHistogram;
- (STSImageHistogram *)computeHistogramOnRect:(STSIRect *)pRect;
- (STSImageHistogram *)computeHistogramOnCGRect:(CGRect)rRect;

- (STSImageHistogram *)computeGrayscaleHistogram;
- (STSImageHistogram *)computeGrayscaleHistogramOnRect:(STSIRect *)pRect;
- (STSImageHistogram *)computeGrayscaleHistogramOnCGRect:(CGRect)rRect;

- (void)equalizeHistogram;

@end
