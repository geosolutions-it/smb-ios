//
//  STSPageStackController.m
//  
//  Created by Szymon Tomasz Stefanek on 2/18/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSPageStackController.h"

#import "STSPageStackView.h"

@interface STSPageStackController ()
{
	STSPageStackView * m_pContainer;
}
@end

@implementation STSPageStackController

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	[self _initPageStackController];
	
	return self;
}

- (void)_initPageStackController
{
	
}

- (void)loadView
{
	m_pContainer = [[STSPageStackView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.view = m_pContainer;
	_stackView = m_pContainer;
}

@end
