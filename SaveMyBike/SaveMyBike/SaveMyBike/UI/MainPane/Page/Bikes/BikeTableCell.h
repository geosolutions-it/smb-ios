//
//  BikeTableCell.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 23/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "STSSimpleTableViewCell.h"

@class Bike;

@interface BikeTableCell : STSSimpleTableViewCell

- (void)setBike:(Bike *)bk;

@end

