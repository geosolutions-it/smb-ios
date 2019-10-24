//
//  Created by Szymon Tomasz Stefanek on 02/06/19.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>





// DEBUG ONLY: DISABLE IN PRODUCTION
//#define SMB_IGNORE_ERRORS_IN_USER_UPDATE 1

// DEBUG ONLY: DISABLE IN PRODUCTION
//#define SMB_ENABLE_GPS_SIMULATION_BY_DEFAULT 1

// DEBUG ONLY: DISABLE IN PRODUCTION
#define SMB_DEVELOPER_VERSION 1

@interface Config : NSObject

+ (Config *)instance;

+ (void)init;
+ (void)done;

@property(nonatomic,readonly) NSString * applicationName;

@property(nonatomic,readonly) NSString * versionString;
@property(nonatomic,readonly) NSString * releaseDate;

@property(nonatomic,readonly) NSString * authDiscoveryURL;
@property(nonatomic,readonly) NSString * authRedirectURI;
@property(nonatomic,readonly) NSString * authClientId;


@property(nonatomic,readonly) NSString * serverURL;
@property(nonatomic,readonly) NSString * fileUploadServerURL;

// white
@property(nonatomic,readonly) UIColor * generalBackgroundColor;
// dark gray
@property(nonatomic,readonly) UIColor * generalForegroundColor;
// magenta
@property(nonatomic,readonly) UIColor * highlight1Color;
// aquamarina
@property(nonatomic,readonly) UIColor * highlight2Color;
// green
@property(nonatomic,readonly) UIColor * highlight3Color;

@property(nonatomic,readonly) CGFloat separatorWidthCM;

@end
