//
//  Created by Szymon Tomasz Stefanek on 02/06/19.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "Globals.h"

#import <UIKit/UIKit.h>

#import "STSCachedImageDownloader.h"
#import "STSNetworkAvailabilityChecker.h"

#import "Config.h"

static Globals * g_pGlobals = nil;

@implementation Globals

- (void)coreInit
{
	_assetPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"SaveMyBikeAssets"];
	
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

#ifdef AT_DEVELOPMENT_BACKEND
	_dataDirectory = [documentsDirectory stringByAppendingPathComponent:@"data_dev"];
#else
	_dataDirectory = [documentsDirectory stringByAppendingPathComponent:@"data"];
#endif

#ifdef SMB_ENABLE_GPS_SIMULATION_BY_DEFAULT
	_simulateGPS = true;
#else
	_simulateGPS = false;
#endif
	
	_currentLanguage = @"en";
	
	[[NSFileManager defaultManager] createDirectoryAtPath:_dataDirectory withIntermediateDirectories:YES attributes:nil error:nil];

	NSString * sCacheRoot = [_dataDirectory stringByAppendingPathComponent:@"cache"];
	
	[[NSFileManager defaultManager] createDirectoryAtPath:sCacheRoot withIntermediateDirectories:YES attributes:nil error:nil];

	_cachedImageDownloader = [[STSCachedImageDownloader alloc] initWithCacheRoot:sCacheRoot];
}

- (void)coreDone
{
}

+ (Globals *)instance
{
	return g_pGlobals;
}

+ (void)init
{
	if(g_pGlobals)
		return;
	g_pGlobals = [Globals new];
	[g_pGlobals coreInit];
}

+ (void)done
{
	if(!g_pGlobals)
		return;
	[g_pGlobals coreDone];
	g_pGlobals = nil;
}


@end
