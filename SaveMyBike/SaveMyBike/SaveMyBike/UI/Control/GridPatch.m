//
//  GridPatch.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 08/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "GridPatch.h"

#import "STSDisplay.h"

@implementation GridPatch

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	STSDisplay * dpy = [STSDisplay instance];
	
	self.backgroundColor = [UIColor whiteColor];
	self.layer.cornerRadius = [dpy centimetersToScreenUnits:0.1];
	self.layer.shadowColor = [[UIColor blackColor] CGColor];
	self.layer.shadowOpacity = 0.5;
	self.layer.shadowRadius = [dpy centimetersToScreenUnits:0.1];
	self.layer.shadowOffset = CGSizeMake(0.0, [dpy centimetersToScreenUnits:0.1]);
	self.clipsToBounds = true;
	self.layer.masksToBounds = false;
	
	return self;
}

@end
