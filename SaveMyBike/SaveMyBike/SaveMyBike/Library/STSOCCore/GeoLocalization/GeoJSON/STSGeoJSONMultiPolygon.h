//
//  STSGeoJSONMultiPolygon.h
//  
//
//  Created by Szymon Tomasz Stefanek on 2/24/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSGeoJSONObject.h"

#import "STSGeoJSONPolygon.h"

@interface STSGeoJSONMultiPolygon : STSGeoJSONObject

@property(nonatomic) NSMutableArray<STSGeoJSONPolygon *> * polygons;

@end
