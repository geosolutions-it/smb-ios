//
//  HomePagePatch.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 20/06/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "GridPatch.h"

@interface HomePagePatch : GridPatch

- (id)initWithIcon:(NSString *)sIcon title:(NSString *)sTitle info:(NSString *)sInfo target:(NSString *)sTarget bottomRowCount:(int)iRowCount;

@end

