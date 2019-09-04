//
//  BackendRequestMyUser.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 27/06/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequest.h"
#import "UserData.h"

@interface BackendRequestGetMyUser : BackendRequest

@property(nonatomic) UserData * userData;

@end
