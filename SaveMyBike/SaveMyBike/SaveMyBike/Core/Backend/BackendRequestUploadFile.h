//
//  BackendRequestUploadFile.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 17/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequest.h"

@interface BackendRequestUploadFile : BackendRequest

@property(nonatomic) NSString * fileName;
@property(nonatomic) NSData * file;

@end

