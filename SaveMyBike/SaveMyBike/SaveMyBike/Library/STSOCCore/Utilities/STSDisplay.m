//
//  STSDisplay.m
//  
//  Created by Szymon Tomasz Stefanek on 1/21/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSDisplay.h"

#import "STSCore.h"
#import "UIDevice+Platform.h"

/*
 
 Apple displays are a huge mess.
 The API is a horror.
 
 - There is no sane way to obtain the PPI of the screen.
 - On the simulator there is no way to obtain the model of the emulated device
 - The devices have a certain number of hardware physical pixels
 - The API works in logical pixels (screen units or points) which are arbitrary mappings of the real hardware pixels
 - Some devices have the concept of "rendered pixels" which are yet another mapping.
 
   The general case looks like this:
 
        screen units (414 x 736)
           |
           |
		   |
		rendered pixels (1242 x 2208)
           |
           |
           |
		physical pixels (1080 x 1920)
 
   On most devices rendered pixels = physical pixels but NOT on iPhone 6 Plus and similar.
 
 - [UIScreen scale] returns the scale factor mapping screen units to rendered pixels
 - [UIScreen nativeScale] returns the scale factor mapping screen units to physical pixels
 
 */

@interface STSDisplay()
{
	// All sizes are in portrait orientation here.
 	// Smaller size is width, bigger size is height
	CGSize m_sSizeInScreenUnits;
	CGSize m_sSizeInPhysicalPixels;
	CGSize m_sSizeInMillimeters;
	
	CGFloat m_fMillimetersToScreenUnitsFactor;
	CGFloat m_fCentimetersToScreenUnitsFactor;

	CGFloat m_fMillimetersToFontUnitsFactor;
	CGFloat m_fCentimetersToFontUnitsFactor;
}
@end

static STSDisplay * g_pInstance = nil;

typedef struct _DeviceInfo
{
	const char * szPlatformId;
	float fScreenWidthInPhysicalPixels;
	float fScreenHeightInPhysicalPixels;
	float fScreenWidthInScreenUnits;
	float fScreenHeightInScreenUnits;
	float fPPI;
	float fScreenWidthInMM;
	float fScreenHeightInMM;
} DeviceInfo;

static DeviceInfo g_aDeviceInfo[] = {
	// Note that 0.0 in this table means "I don't know / I haven't tried".
	//{ "AppleTV2,1", 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, // Apple TV 2G
	//{ "AppleTV3,1", 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, // Apple TV 3G
	//{ "AppleTV3,2", 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, // Apple TV 3G
	//{ "AppleTV5,3", 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, // Apple TV 4G
	{ "Watch1,1", 272.0f, 340.0f, 0.0f, 0.0f,  326.0f, 21.19f, 26.49f }, // Apple Watch
	{ "Watch1,2", 272.0f, 340.0f, 0.0f, 0.0f, 326.0f, 21.19f, 26.49f }, // Apple Watch // WARNING: There seems to be also a 42 mm model with bigger screen
	{ "iPhone1,1", 320.0f, 480.0f, 320.0f, 480.0f, 163.0f, 49.86f, 74.79f }, // iPhone
	{ "iPhone1,2", 320.0f, 480.0f, 320.0f, 480.0f, 163.0f, 49.86f, 74.79f }, // iPhone 3G
	{ "iPhone2,1", 320.0f, 480.0f, 320.0f, 480.0f, 163.0f, 49.86f, 74.79f }, // iPhone 3GS
	{ "iPhone3,1", 640.0f, 960.0f, 320.0f, 480.0f, 326.0f, 49.86f, 74.79f }, // iPhone 4
	{ "iPhone3,2", 640.0f, 960.0f, 320.0f, 480.0f, 326.0f, 49.86f, 74.79f }, // iPhone 4
	{ "iPhone3,3", 640.0f, 960.0f, 320.0f, 480.0f, 326.0f, 49.86f, 74.79f }, // iPhone 4 (CDMA)
	{ "iPhone4,1", 640.0f, 960.0f, 320.0f, 480.0f, 326.0f, 49.86f, 74.79f }, // iPhone 4S
	{ "iPhone5,1", 640.0f, 1136.0f, 320.0f, 568.0f, 326.0f, 49.86f, 88.51f }, // iPhone 5 (GSM)
	{ "iPhone5,2", 640.0f, 1136.0f, 320.0f, 568.0f, 326.0f, 49.86f, 88.51f }, // iPhone 5 (GSM+CDMA)
	{ "iPhone5,3", 640.0f, 1136.0f, 320.0f, 568.0f, 326.0f, 49.86f, 88.51f }, // iPhone 5C (GSM)
	{ "iPhone5,4", 640.0f, 1136.0f, 320.0f, 568.0f, 326.0f, 49.86f, 88.51f }, // iPhone 5C (GSM+CDMA)
	{ "iPhone6,1", 640.0f, 1136.0f, 320.0f, 568.0f, 326.0f, 49.86f, 88.51f }, // iPhone 5S (GSM)
	{ "iPhone6,2", 640.0f, 1136.0f, 320.0f, 568.0f, 326.0f, 49.86f, 88.51f }, // iPhone 5S (GSM+CDMA)
	{ "iPhone7,1", 1080.0f, 1920.0f, 414.0f, 736.0f, 401.0f, 68.40f, 121.61f }, // iPhone 6 Plus
	{ "iPhone7,2", 750.0f, 1334.0f, 375.0f, 667.0f, 326.0f, 58.43f, 103.93f }, // iPhone 6
	{ "iPhone8,1", 750.0f, 1334.0f, 375.0f, 667.0f, 326.0f, 58.43f, 103.93f }, // iPhone 6s
	{ "iPhone8,2", 1080.0f, 1920.0f, 414.0f, 736.0f, 401.0f, 68.40f, 121.61f }, // iPhone 6s Plus
	{ "iPhone8,4", 640.0f, 1136.0f, 320.0f, 568.0f, 326.0f, 49.86f, 88.51f }, // iPhone SE // special edition
	{ "iPhone9,1", 750.0f, 1334.0f, 375.0f, 667.0f, 326.0f, 58.43f, 103.93f }, // iPhone 7 (CDMA)
	{ "iPhone9,2", 1080.0f, 1920.0f, 414.0f, 736.0f, 401.0f, 68.40f, 121.61f }, // iPhone 7 Plus (CDMA)
	{ "iPhone9,3", 750.0f, 1334.0f, 375.0f, 667.0f, 326.0f, 58.43f, 103.93f }, // iPhone 7 (global)
	{ "iPhone9,4", 1080.0f, 1920.0f, 414.0f, 736.0f, 401.0f, 68.40f, 121.61f }, // iPhone 7 Plus (global)
	
	{ "iPhone10,1", 750.0f, 1334.0f, 375.0f, 667.0f, 326.0f, 58.43f, 103.93f }, // iPhone 8
	{ "iPhone10,2", 1080.0f, 1920.0f, 414.0f, 736.0f, 401.0f, 68.40f, 121.61f }, // iPhone 8 Plus
	{ "iPhone10,3", 1125.0f, 2436.0f, 375.0f, 812.0f, 458.0f, 62.4f, 135.1f }, // iPhone X
	{ "iPhone10,4", 750.0f, 1334.0f, 375.0f, 667.0f, 326.0f, 58.43f, 103.93f }, // iPhone 8 (ALT)
	{ "iPhone10,5", 1080.0f, 1920.0f, 414.0f, 736.0f, 401.0f, 68.40f, 121.61f }, // iPhone 8 Plus (ALT)
	{ "iPhone10,6", 1125.0f, 2436.0f, 375.0f, 812.0f, 458.0f, 62.4f, 135.1f }, // iPhone X (ALT)

	{ "iPhone11,2", 1125.0f, 2436.0f, 375.0f, 812.0f, 458.0f, 63.f, 134.f }, // iPhone XS
	{ "iPhone11,6", 1242.0f, 2688.0f, 414.0f, 896.0f, 458.0f, 69.f, 150.f }, // iPhone XS Max
	{ "iPhone11,8", 828.0f, 1792.0f, 414.0f, 896.0f, 326.0f, 65.f, 141.f }, // iPhone XR

	{ "iPod1,1", 320.0f, 480.0f, 320.0f, 480.0f, 163.0f, 49.86f, 74.79f }, // iPod Touch
	{ "iPod2,1", 320.0f, 480.0f, 320.0f, 480.0f, 163.0f, 49.86f, 74.79f }, // iPod Touch 2G
	{ "iPod3,1", 320.0f, 480.0f, 320.0f, 480.0f, 163.0f, 49.86f, 74.79f }, // iPod Touch 3G
	{ "iPod4,1", 640.0f, 960.0f, 320.0f, 480.0f, 326.0f, 49.86f, 74.79f }, // iPod Touch 4G
	{ "iPod5,1", 640.0f, 1136.0f, 320.0f, 480.0f, 326.0f, 49.86f, 88.51f }, // iPod Touch 5G
	{ "iPod7,1", 640.0f, 1136.0f, 320.0f, 480.0f, 326.0f, 49.86f, 88.51f }, // iPod Touch 6G
	{ "iPad1,1", 768.0f, 1024.0f, 768.0f, 1024.0f, 132.0f, 147.78f, 197.04f }, // iPad
	{ "iPad2,1", 768.0f, 1024.0f, 768.0f, 1024.0f, 132.0f, 147.78f, 197.04f }, // iPad 2 (WiFi)
	{ "iPad2,2", 768.0f, 1024.0f, 768.0f, 1024.0f, 132.0f, 147.78f, 197.04f }, // iPad 2 (GSM)
	{ "iPad2,3", 768.0f, 1024.0f, 768.0f, 1024.0f, 132.0f, 147.78f, 197.04f }, // iPad 2 (CDMA)
	{ "iPad2,4", 768.0f, 1024.0f, 768.0f, 1024.0f, 132.0f, 147.78f, 197.04f }, // iPad 2 (WiFi)
	{ "iPad3,1", 1536.0f, 2048.0f, 768.0f, 1024.0f, 264.0f, 147.78f, 197.04f }, // iPad 3 (WiFi)
	{ "iPad3,2", 1536.0f, 2048.0f, 768.0f, 1024.0f, 264.0f, 147.78f, 197.04f }, // iPad 3 (GSM+CDMA)
	{ "iPad3,3", 1536.0f, 2048.0f, 768.0f, 1024.0f, 264.0f, 147.78f, 197.04f }, // iPad 3 (GSM)
	{ "iPad3,4", 1536.0f, 2048.0f, 768.0f, 1024.0f, 264.0f, 147.78f, 197.04f }, // iPad 4 (WiFi)
	{ "iPad3,5", 1536.0f, 2048.0f, 768.0f, 1024.0f, 264.0f, 147.78f, 197.04f }, // iPad 4 (GSM)
	{ "iPad3,6", 1536.0f, 2048.0f, 768.0f, 1024.0f, 264.0f, 147.78f, 197.04f }, // iPad 4 (GSM+CDMA)
	{ "iPad4,1", 1536.0f, 2048.0f, 768.0f, 1024.0f, 264.0f, 147.78f, 197.04f }, // iPad Air (WiFi)
	{ "iPad4,2", 1536.0f, 2048.0f, 768.0f, 1024.0f, 264.0f, 147.78f, 197.04f }, // iPad Air (Cellular)
	{ "iPad4,3", 1536.0f, 2048.0f, 768.0f, 1024.0f, 264.0f, 147.78f, 197.04f }, // iPad Air
	{ "iPad5,3", 1536.0f, 2048.0f, 768.0f, 1024.0f, 264.0f, 147.78f, 197.04f }, // iPad Air 2 (WiFi)
	{ "iPad5,4", 1536.0f, 2048.0f, 768.0f, 1024.0f, 264.0f, 147.78f, 197.04f }, // iPad Air 2 (Cellular)
	{ "iPad6,3", 1536.0f, 2048.0f, 768.0f, 1024.0f, 264.0f, 147.78f, 197.04f }, // iPad Pro 9.7 inch (WiFi)
	{ "iPad6,4", 1536.0f, 2048.0f, 768.0f, 1024.0f, 264.0f, 147.78f, 197.04f }, // iPad Pro 9.7 inch (Cellular)
	{ "iPad6,7", 2048.0f, 2732.0f, 1024.0f, 1366.0f, 264.0f, 197.04f, 262.85f }, // iPad Pro 12.9 inch (WiFi)
	{ "iPad6,8", 2048.0f, 2732.0f, 1024.0f, 1366.0f, 264.0f, 197.04f, 262.85f }, // iPad Pro 12.9 inch (Cellular)
	{ "iPad2,5", 768.0f, 1024.0f, 768.0f, 1024.0f, 163.0f, 119.67f, 159.56f }, // iPad Mini (WiFi)
	{ "iPad2,6", 1536.0f, 2048.0f, 768.0f, 1024.0f, 326.0f, 119.67f, 159.56f }, // iPad Mini (GSM)
	{ "iPad2,7", 1536.0f, 2048.0f, 768.0f, 1024.0f, 326.0f, 119.67f, 159.56f }, // iPad Mini (GSM+CDMA)
	{ "iPad4,4", 1536.0f, 2048.0f, 768.0f, 1024.0f, 326.0f, 119.67f, 159.56f }, // iPad Mini 2 (WiFi)
	{ "iPad4,5", 1536.0f, 2048.0f, 768.0f, 1024.0f, 326.0f, 119.67f, 159.56f }, // iPad Mini 2 (Cellular)
	{ "iPad4,6", 1536.0f, 2048.0f, 768.0f, 1024.0f, 326.0f, 119.67f, 159.56f }, // iPad Mini 2
	{ "iPad4,7", 1536.0f, 2048.0f, 768.0f, 1024.0f, 326.0f, 119.67f, 159.56f }, // iPad mini 3 (WiFi)
	{ "iPad4,8", 1536.0f, 2048.0f, 768.0f, 1024.0f, 326.0f, 119.67f, 159.56f }, // iPad mini 3 (Cellular)
	{ "iPad4,9", 1536.0f, 2048.0f, 768.0f, 1024.0f, 326.0f, 119.67f, 159.56f }, // iPad mini 3 (China Model)
	{ "iPad5,1", 1536.0f, 2048.0f, 768.0f, 1024.0f, 326.0f, 119.67f, 159.56f }, // iPad mini 4 (WiFi)
	{ "iPad5,2", 1536.0f, 2048.0f, 768.0f, 1024.0f, 326.0f, 119.67f, 159.56f }, // iPad mini 4 (Cellular)
	//{ "i386", 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, // Simulator
	//{ "x86_64", 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, // Simulator
	{ NULL, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }
};



@implementation STSDisplay



-(id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	CGSize sScreenSize = [UIScreen mainScreen].bounds.size;
	
	if(sScreenSize.width > sScreenSize.height)
	{
		// landscape
		m_sSizeInScreenUnits.width = sScreenSize.height;
		m_sSizeInScreenUnits.height = sScreenSize.width;
	} else {
		// portrait
		m_sSizeInScreenUnits.width = sScreenSize.width;
		m_sSizeInScreenUnits.height = sScreenSize.height;
	}

	NSString * szPlatformId = [[UIDevice currentDevice] platformId];
	
	const char * szPlatformIdUTF8 = [szPlatformId UTF8String];
	DeviceInfo * pDev = g_aDeviceInfo;
	
	DeviceInfo * pFound = NULL;
	
	while(pDev->szPlatformId)
	{
		if(strcmp(szPlatformIdUTF8,pDev->szPlatformId) == 0)
		{
			pFound = pDev;
			break;
		}
		pDev++;
	}

	if(!pFound)
	{
		STS_CORE_LOG_ERROR(@"Can't determine the device model (running on simulator?): trying alternate mode, but display metrics may be wrong");

		// Try in a differnt way.
		float fScale = [UIScreen mainScreen].nativeScale;

		m_sSizeInPhysicalPixels.width = m_sSizeInScreenUnits.width * fScale;
		m_sSizeInPhysicalPixels.height = m_sSizeInScreenUnits.height * fScale;
		
		pDev = g_aDeviceInfo;

		while(pDev->szPlatformId)
		{
			if(
			   (fabs(pDev->fScreenWidthInScreenUnits - m_sSizeInScreenUnits.width) < 1.0f) &&
			   (fabs(pDev->fScreenHeightInScreenUnits - m_sSizeInScreenUnits.height) < 1.0f) &&
			   (fabs(pDev->fScreenWidthInPhysicalPixels - m_sSizeInPhysicalPixels.width) < 1.0f) &&
			   (fabs(pDev->fScreenHeightInPhysicalPixels - m_sSizeInPhysicalPixels.height) < 1.0f)
			)
			{
				pFound = pDev;
				break;
			}
			pDev++;
		}

		if(!pFound)
		{
			STS_CORE_LOG_ERROR(@"Can't determine the device model: display metrics will be wrong");
		}
	}
	
	if(pFound)
	{
		m_sSizeInMillimeters.width = pFound->fScreenWidthInMM;
		m_sSizeInMillimeters.height = pFound->fScreenHeightInMM;
		
		m_sSizeInPhysicalPixels.width = pFound->fScreenWidthInPhysicalPixels;
		m_sSizeInPhysicalPixels.height = pFound->fScreenHeightInPhysicalPixels;
	} else {
		// guess... 326ppi
		m_sSizeInMillimeters.width = (m_sSizeInPhysicalPixels.width / 326.0f) * 25.4f;
		m_sSizeInMillimeters.height = (m_sSizeInPhysicalPixels.height / 326.0f) * 25.4f;
	}
	
	STS_CORE_LOG(
		@"Display logical(%f,%f) physical(%f,%f) mm(%f,%f) platform(%s) factor(%f) scale(%f) nativeScale(%f)",
		m_sSizeInScreenUnits.width,
		m_sSizeInScreenUnits.height,
		m_sSizeInPhysicalPixels.width,
		m_sSizeInPhysicalPixels.height,
		m_sSizeInMillimeters.width,
		m_sSizeInMillimeters.height,
		pFound ? pFound->szPlatformId : "no-platform",
		m_sSizeInPhysicalPixels.width / m_sSizeInScreenUnits.width,
		[UIScreen mainScreen].scale,
		[UIScreen mainScreen].nativeScale
	);
	
	m_fMillimetersToScreenUnitsFactor = m_sSizeInScreenUnits.width / m_sSizeInMillimeters.width;
	m_fCentimetersToScreenUnitsFactor = m_fMillimetersToScreenUnitsFactor * 10.0;

	// Now fonts *seem* to always use points, which are defined to be 1/72th of an inch.
	// This is aproximate, since the font glyphs can actually be a bit larger or smaller than the font's reference system unit square...
	// This is also wrong since screen scale must be also taken into account
	// An inch is 25,4 mm
	// A point is 25,4 / 72.0 mm
	m_fMillimetersToFontUnitsFactor = (1.0 / (25.4 / 72.0)) * 2.0; // * [UIScreen mainScreen].scale;
	m_fCentimetersToFontUnitsFactor = m_fMillimetersToFontUnitsFactor * 10.0;
	
	return self;
}

-(CGFloat)centimetersToScreenUnits:(CGFloat)fCentimeters
{
	return fCentimeters * m_fCentimetersToScreenUnitsFactor;
}

-(CGFloat)millimetersToScreenUnits:(CGFloat)fMillimeters
{
	return fMillimeters * m_fMillimetersToScreenUnitsFactor;
}

-(CGFloat)screenUnitsToMillimeters:(CGFloat)fScreenUnits
{
	return fScreenUnits / m_fMillimetersToScreenUnitsFactor;
}

-(CGFloat)screenUnitsToCentimeters:(CGFloat)fScreenUnits
{
	return fScreenUnits / m_fCentimetersToScreenUnitsFactor;
}

-(CGFloat)minorScreenDimensionFractionToScreenUnits:(CGFloat)fFraction
{
	return m_sSizeInScreenUnits.width * fFraction;
}

-(CGFloat)minorScreenDimensionFractionToScreenUnits:(CGFloat)fFraction notLessThanCM:(CGFloat)fMinCM notMoreThanCM:(CGFloat)fMaxCM
{
	CGFloat mi = [self centimetersToScreenUnits:fMinCM];
	CGFloat fr = [self minorScreenDimensionFractionToScreenUnits:fFraction];
	
	if(fr < mi)
		return mi;

	CGFloat mx = [self centimetersToScreenUnits:fMaxCM];
	if(fr > mx)
		return mx;
	
	return fr;
}

-(CGFloat)majorScreenDimensionFractionToScreenUnits:(CGFloat)fFraction notLessThanCM:(CGFloat)fMinCM notMoreThanCM:(CGFloat)fMaxCM
{
	CGFloat mi = [self centimetersToScreenUnits:fMinCM];
	CGFloat fr = [self majorScreenDimensionFractionToScreenUnits:fFraction];
	
	if(fr < mi)
		return mi;

	CGFloat mx = [self centimetersToScreenUnits:fMaxCM];
	if(fr > mx)
		return mx;
	
	return fr;
}


-(CGFloat)majorScreenDimensionFractionToScreenUnits:(CGFloat)fFraction
{
	return m_sSizeInScreenUnits.height * fFraction;
}

-(CGFloat)minorScreenDimensionFractionToCentimeters:(CGFloat)fFraction
{
	return m_sSizeInScreenUnits.width * fFraction / m_fCentimetersToScreenUnitsFactor;
}

-(CGFloat)majorScreenDimensionFractionToCentimeters:(CGFloat)fFraction
{
	return m_sSizeInScreenUnits.height * fFraction / m_fCentimetersToScreenUnitsFactor;
}


-(CGFloat)centimetersToFontUnits:(CGFloat)fCentimeters
{
	return fCentimeters * m_fCentimetersToFontUnitsFactor;
}

-(CGFloat)millimetersToFontUnits:(CGFloat)fMillimeters
{
	return fMillimeters * m_fMillimetersToFontUnitsFactor;
}


+(STSDisplay *)instance
{
	if(!g_pInstance)
		g_pInstance = [[STSDisplay alloc] init];
	return g_pInstance;
}

@end
