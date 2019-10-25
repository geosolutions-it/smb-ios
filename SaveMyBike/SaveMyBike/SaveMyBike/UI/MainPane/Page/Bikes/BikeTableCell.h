//
//  BikeTableCell.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 23/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "STSSimpleTableViewCell.h"

@class Bike;
@class BikeListView;

@interface BikeTableCell : STSSimpleTableViewCell

- (void)setBike:(Bike *)bk andListView:(BikeListView *)lv;

@end

