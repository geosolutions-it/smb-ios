//
//  Created by Szymon Tomasz Stefanek on 02/06/19.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "Config.h"

#import "UIColor+ExtraFormat.h"

static Config * g_pConfig = nil;

@implementation Config

- (void)coreInit
{
	_applicationName = @"Save My Bike";
	
	_versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
	_releaseDate = @"2019.09.25";
	
	//_serverURL = @"https://goodgo.savemybike.geo-solutions.it";
	_serverURL = @"https://dev.savemybike.geo-solutions.it";
	_fileUploadServerURL = @"https://ex2rxvvhpc.execute-api.us-west-2.amazonaws.com/prod";
	
	// white
	_generalBackgroundColor = [UIColor colorWithIntValue:0xffffffff];
	// dark gray
	_generalForegroundColor = [UIColor colorWithIntValue:0xff646464];
	// magenta
	_highlight1Color = [UIColor colorWithIntValue:0xfff804b0];
	// aquamarina
	_highlight2Color = [UIColor colorWithIntValue:0xff2ec6c1];
	// green
	_highlight3Color = [UIColor colorWithIntValue:0xff93c95f];
	
	_separatorWidthCM = 0.05;
}

- (void)coreDone
{
	
}

+ (Config *)instance
{
	return g_pConfig;
}

+ (void)init
{
	if(g_pConfig)
		return;
	g_pConfig = [Config new];
	[g_pConfig coreInit];
}

+ (void)done
{
	if(!g_pConfig)
		return;
	[g_pConfig coreDone];
	g_pConfig = nil;
}

@end
