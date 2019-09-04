//
//  NotificationManager.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 02/09/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NotificationManager : NSObject

+ (NotificationManager *)instance;

+ (void)create;
+ (void)destroy;

- (void)maybeStartNotificationRegistration;

- (void)startNotificationUnregistration;

@end
