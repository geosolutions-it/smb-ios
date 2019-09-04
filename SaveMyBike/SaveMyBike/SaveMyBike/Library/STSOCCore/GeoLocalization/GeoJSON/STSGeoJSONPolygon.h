//
//  STSGeoJSONPolygon.h
//  
//
//  Created by Szymon Tomasz Stefanek on 2/24/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSGeoJSONObject.h"

#import "STSGeoCoordinate.h"

@interface STSGeoJSONPolygon : STSGeoJSONObject

@property (nonatomic) NSMutableArray<STSGeoCoordinate *> * contour;

@end
