//
//  BikeObservationsTab.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 28/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "STSGridLayoutView.h"

@class Bike;
@class BikeObservation;

@interface BikeObservationsTab : STSGridLayoutView

- (id)initWithBike:(Bike *)pBike;

- (void)setCurrentObservation:(BikeObservation *)o;

- (void)setObservationCount:(int)iCount;

@end

