//
//  STSImage+Grayscale.h
//  STSCore
//
//  Created by Szymon Tomasz Stefanek on 3/29/13.
//

#import <Foundation/Foundation.h>

#import "STSImage.h"
#import "STSIRect.h"

@interface STSImage(Grayscale)

- (STSImage *)convertToGrayscale;

@end
