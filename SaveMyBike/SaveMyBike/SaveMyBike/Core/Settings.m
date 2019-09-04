//
//  Created by Szymon Tomasz Stefanek on 02/06/19.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "Settings.h"

#import "STSFile.h"
#import "Config.h"

static Settings * g_pSettings = nil;


@implementation Settings
{
	NSString * m_szPath;
}

- (void)coreCreate:(NSString *)szPath
{
	m_szPath = szPath;
}

- (void)coreDestroy
{	
}

+ (Settings *)instance
{
	return g_pSettings;
}

+ (void)create:(NSString *)szPath
{
	if(g_pSettings)
		return;
	g_pSettings = [Settings new];
	[g_pSettings coreCreate:szPath];
}

+ (void)destroy
{
	if(!g_pSettings)
		return;
	[g_pSettings coreDestroy];
	g_pSettings = nil;
}

// Strong encryption is problematic on iOS

#define KEY_LENGTH 16
static unsigned char k[KEY_LENGTH] = {
	0xe2, 0x99, 0x23, 0x33, 0x23, 0xe3, 0xee, 0x59,
	0xf1, 0xcf, 0xf7, 0xa4, 0xac, 0x70, 0x42, 0x12
};

- (bool)load
{
	NSData * d = [STSFile readDataFromPath:m_szPath];
	if(!d || (d.length < 1))
	{
		STS_CORE_LOG(@"No settings at path %@",m_szPath);
		[self initDefaults];
		return false;
	}
	
	NSMutableData * md = [NSMutableData dataWithData:d];
	for(NSUInteger u = 0;u < md.length;u++)
	{
		unsigned char * c = [md mutableBytes];
		c[u] ^= k[u % KEY_LENGTH];
	}
	
	NSString * szError = [self decodeJSONData:md];
	if(szError)
	{
		STS_CORE_LOG_ERROR(@"Failed to read settings: %@",szError);
		[self initDefaults];
	}

	return szError == nil;
}

- (void)initDefaults
{
	self.lastFirebaseToken = @"";
	self.uniqueId = @"";
}

- (bool)save
{
	NSData * d = [self encodeToJSONData];
	
	NSMutableData * md = [NSMutableData dataWithData:d];
	for(NSUInteger u = 0;u < md.length;u++)
	{
		unsigned char * c = [md mutableBytes];
		c[u] ^= k[u % KEY_LENGTH];
	}

	NSString * szError = [STSFile writeData:md toPath:m_szPath];
	
	if(szError)
	{
		STS_CORE_LOG_ERROR(@"Failed to write settings: %@",szError);
	}
	
	return szError == nil;
}

@end
