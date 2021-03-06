//
//  BikeListView.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 07/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "RemoteItemList.h"

@class Bike;

@interface BikeListView : RemoteItemList

- (void)onActivate;
- (void)onDeactivate;

- (void)onBikeTableCellStatusButtonPressed:(Bike *)bk;

@end

