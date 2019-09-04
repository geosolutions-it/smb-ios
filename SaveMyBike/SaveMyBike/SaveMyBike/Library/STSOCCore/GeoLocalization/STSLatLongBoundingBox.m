//
//  STSLatLongBoundingBox.m
//  
//  Created by Szymon Tomasz Stefanek on 2/24/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSLatLongBoundingBox.h"

@implementation STSLatLongBoundingBox

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	self.north = -999.9; //  invalid
	return self;
}

- (id)initWithNorth:(double)n east:(double)e south:(double)s west:(double)w
{
	self = [super init];
	if(!self)
		return nil;
	self.north = n;
	self.east = e;
	self.south = s;
	self.west = w;
	return self;
}

- (BOOL)isValid
{
	if(self.north < -90.0)
		return false;
	if(self.north > 90.0)
		return false;
	if(self.south < -90.0)
		return false;
	if(self.south > 90.0)
		return false;
	if(self.east < -180.0)
		return false;
	if(self.east > 180.0)
		return false;
	if(self.west < -180.0)
		return false;
	if(self.west > 180.0)
		return false;
	if(self.north < self.south)
		return false;
	if(self.east < self.west)
		return false;
	return true;
}

- (void)scaleAboutCenter:(double)dFactor
{
	if(![self isValid])
		return;
	
	double ns = fabs(self.north - self.south);
	double nsx = ns * dFactor;
	double nsa = (nsx - ns) / 2.0;
	double ew = fabs(self.east - self.west);
	double ewx = ew * dFactor;
	double ewa = (ewx - ew) / 2.0;
	
	self.north += nsa;
	self.south -= nsa;
	self.east += ewa;
	self.west -= ewa;
}

- (void)extend:(STSLatLongBoundingBox *)pBox
{
	if(!pBox)
		return;
	if(pBox.north > self.north)
		self.north = pBox.north;
	if(pBox.south < self.south)
		self.south = pBox.south;
	if(pBox.east < self.east)
		self.east = pBox.east;
	if(pBox.west > self.west)
		self.west = pBox.west;
}

- (void)extendBy:(double)dVal
{
	self.north += dVal;
	self.south -= dVal;
	self.east += dVal;
	self.west -= dVal;
}


@end
