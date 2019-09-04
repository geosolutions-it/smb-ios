//
//  TrackDetailsView.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 22/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "STSGridLayoutView.h"

@class Track;

@interface TrackDetailsView : STSGridLayoutView

- (float)headerHeight;

- (void)setupForTrack:(Track *)trk;

@end
