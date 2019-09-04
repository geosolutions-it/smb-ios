#import "BikeObservation.h"

#import "STSJSON.h"
#import "STSTypeConversion.h"

#import "BikeObservationProperties.h"

@implementation BikeObservation

- (NSString *)decodeJSON:(id)x
{
	if(!x)
		return @"null object";

	NSDictionary * d = [STSTypeConversion objectToDictionary:x withDefault:nil];
	if(!d)
		return @"Bad dictionary object";

	id ob = [d objectForKey:@"geometry"];
	if(!ob)
	{
		self.geometry = nil;
	} else {
		self.geometry = [ob JSONRepresentation];
	}
	
	ob = [d objectForKey:@"properties"];
	if(!ob)
	{
		self.properties = nil;
	} else {
		NSDictionary * pDict = [STSTypeConversion objectToDictionary:ob withDefault:nil];
		if(!pDict)
		{
			self.properties = nil;
		} else {
			self.properties = [BikeObservationProperties new];
			NSString * szErr = [self.properties decodeJSON:pDict];
			if((szErr != nil) && (szErr.length > 0))
				self.properties = nil;
		}
	}
	return nil;
}

@end

