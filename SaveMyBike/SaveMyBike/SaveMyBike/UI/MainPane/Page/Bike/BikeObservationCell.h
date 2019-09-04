//
//  BikeObservationCell.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 28/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "STSSimpleTableViewCell.h"

@class BikeObservation;


@interface BikeObservationCell : STSSimpleTableViewCell

- (void)setupForBikeObservation:(BikeObservation *)o;

@end

