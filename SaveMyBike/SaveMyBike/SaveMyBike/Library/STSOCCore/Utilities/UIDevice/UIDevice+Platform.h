//
//  UIDevice+Platform.h
//
//  Created by Szymon Tomasz Stefanek on 1/29/14.
//

#import <UIKit/UIKit.h>

typedef enum _STSDevicePlatform
{
	STSPlatformiPhone,
	STSPlatformiPhone3G,
	STSPlatformiPhone3GS,
	STSPlatformiPhone4,
	STSPlatformiPhone4S,
	STSPlatformiPhone5,
	STSPlatformiPhone5C,
	STSPlatformiPhone5S,
	STSPlatformiPhone6,
	STSPlatformiPhone6S,
	STSPlatformiPhone6SPlus,
	STSPlatformiPhoneSE,
	STSPlatformiPhone7,
	STSPlatformiPhone7Plus,
	STSPlatformUnknown
} STSDevicePlatform;

@interface UIDevice (Platform)



- (NSString *) platformId;
- (NSString *) platformDescription;
@end
