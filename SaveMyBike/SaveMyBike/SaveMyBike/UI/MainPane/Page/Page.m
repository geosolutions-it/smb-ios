//
//  Page.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 1/6/19.
//  Copyright © 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import "Page.h"

#import "Config.h"

@implementation Page

- (id)init
{
	self = [super init];
	if(!self)
		return nil;

	self.backgroundColor = [Config instance].generalBackgroundColor;

	return self;
}

@end
