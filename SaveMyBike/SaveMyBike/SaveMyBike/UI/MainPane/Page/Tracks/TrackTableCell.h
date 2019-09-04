//
//  TracksPage.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 17/06/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "STSSimpleTableViewCell.h"

@class Track;

@interface TrackTableCell : STSSimpleTableViewCell

- (void)setupForTrack:(Track *)trk;

@end


