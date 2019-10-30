//
//  MapDisplay.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 20/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "STSGridLayoutView.h"

#import <GoogleMaps/GoogleMaps.h>

@class STSGeoCoordinate;
@class STSLatLongBoundingBox;

@interface MapDisplay : STSGridLayoutView

- (id)init;

- (void)removeAllOverlays;

- (GMSMapView *)mapView;

- (void)enableMyLocationButton;
- (void)enableSearchBox;

- (void)addMarkerWithLatitude:(double)lat longitude:(double)lon title:(NSString *)szTitle andDescription:(NSString *)szDescription;
- (void)animateToLatitude:(double)lat longitude:(double)lon zoom:(double)z;
- (void)animateTo:(GMSCoordinateBounds *)bnds;
- (void)animateToBoundingBox:(STSLatLongBoundingBox *)box;
- (void)createPathForPoints:(NSMutableArray<STSGeoCoordinate *> *)coords;
- (void)zoomToMyLocationWhenAvailable;

@end

