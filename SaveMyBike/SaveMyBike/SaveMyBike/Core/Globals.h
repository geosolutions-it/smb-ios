//
//  Created by Szymon Tomasz Stefanek on 02/06/19.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserData.h"

@class STSCachedImageDownloader;

@interface Globals : NSObject

+ (Globals *)instance;

+ (void)init;
+ (void)done;

@property(nonatomic) NSString * currentLanguage;
@property(nonatomic,readonly) NSString * assetPath;
@property(nonatomic,readonly) NSString * dataDirectory;
@property(nonatomic) NSString * firebaseToken;
@property(nonatomic) NSString * authToken;
@property(nonatomic) UserData * userData;
@property(nonatomic) bool simulateGPS;
@property(nonatomic,retain) STSCachedImageDownloader * cachedImageDownloader;

@end
