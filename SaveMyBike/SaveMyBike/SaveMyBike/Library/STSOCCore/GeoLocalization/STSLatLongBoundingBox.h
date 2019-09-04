//
//  STSLatLongBoundingBox.h
//  
//  Created by Szymon Tomasz Stefanek on 2/24/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STSLatLongBoundingBox : NSObject

@property(nonatomic) double north; // max latitude
@property(nonatomic) double east; // max longitude
@property(nonatomic) double south; // min latitude
@property(nonatomic) double west; // min longitude

- (id)init;
- (id)initWithNorth:(double)n east:(double)e south:(double)s west:(double)w;

- (BOOL)isValid;
- (void)scaleAboutCenter:(double)dFactor;
- (void)extend:(STSLatLongBoundingBox *)pBox;
- (void)extendBy:(double)dVal;

@end
