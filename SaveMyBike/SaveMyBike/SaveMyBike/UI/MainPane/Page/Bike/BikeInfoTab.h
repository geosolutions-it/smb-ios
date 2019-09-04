//
//  BikeInfoTab.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 28/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "STSSingleViewScroller.h"

@class Bike;

@interface BikeInfoTab : STSSingleViewScroller

- (id)initWithBike:(Bike *)bk;

@end

