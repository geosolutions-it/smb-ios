//
//  STSPageStackAction.m
//  
//  Created by Szymon Tomasz Stefanek on 2/18/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSPageStackAction.h"

#import "STSPageStackView.h"

@implementation STSPageStackAction

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	[self _initPageStackAction];
	
	return self;
}

- (void)_initPageStackAction
{
	self.enabled = YES;
}

- (void)setIcon:(NSString *)szIcon
{
	_icon = szIcon;
	self.changed = true;
	if(self.stackView)
		[self.stackView triggerUpdateActionBar];
}

- (void)setEnabled:(BOOL)enabled
{
	if(_enabled == enabled)
		return;
	_enabled = enabled;
	if(self.stackView)
		[self.stackView triggerUpdateActionBar];
}

@end
