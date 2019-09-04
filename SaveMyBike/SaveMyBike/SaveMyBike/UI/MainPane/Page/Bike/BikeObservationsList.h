//
//  BikeObservationsList.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 28/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "RemoteItemList.h"

@class Bike;
@class BikeObservationsTab;

@interface BikeObservationsList : RemoteItemList

- (id)initWithBike:(Bike *)bk andObservationTab:(BikeObservationsTab *)pTab;

@end
