//
//  Created by Szymon Tomasz Stefanek on 02/06/19.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequest.h"
#import "Globals.h"
#import "Config.h"

#import "STSCore.h"
#import "STSTypeConversion.h"
#import "STSI18N.h"
#import "AuthManager.h"

@interface BackendRequest()<STSURLJSONObjectDownloadDelegate>
{
	bool m_bRetriedAfterAuthError;
	bool m_bEnqueuedInAuthManager;
}

@end

@implementation BackendRequest

- (id)init
{
	self = [super init];
	if(!self)
		return nil;

	m_bRetriedAfterAuthError = false;
	m_bEnqueuedInAuthManager = false;
	
	[self addHeader:@"Authorization" withValue:[NSString stringWithFormat:@"Bearer %@",[Globals instance].authToken]];

	self.delegate = self;
	self.succeeded = false;
	self.error = __trCtx(@"Request not started",@"BackendRequest");

	return self;
}

- (void)onProcessObject:(id)ob
{
	self.error = __trCtx(@"Not implemented", @"BackendRequest");
}

- (bool)_restartAfterAuth
{
	m_bEnqueuedInAuthManager = false;
	[self addHeader:@"Authorization" withValue:[NSString stringWithFormat:@"Bearer %@",[Globals instance].authToken]];
	return [self start];
}

- (void)_failWithError:(NSString *)sError
{
	m_bEnqueuedInAuthManager = false;
	self.succeeded = false;
	self.error = sError;
	[self.backendRequestDelegate backendRequestCompleted:self];
}

- (void)cancel:(bool)bTriggerCancellationError
{
	if(m_bEnqueuedInAuthManager)
	{
		[[AuthManager instance] dequeueRequest:self];
		m_bEnqueuedInAuthManager = false;
	}
	[super cancel:bTriggerCancellationError];
}

- (id<JSONConvertible>)decodeObject:(id)ob intoResult:(id<JSONConvertible>)res;
{
	if(!res)
	{
		self.error = @"Internal error: no result";
		return nil;
	}
	
	if(!ob)
	{
		self.error = @"Internal error: no object";
		return nil;
	}
	
	NSString * sErr = [res decodeJSON:ob];
	if(sErr)
	{
		self.error = [NSString stringWithFormat:__trCtx(@"Failed to decode object: %s",@"BackendRequest"),sErr];
		return nil;
	}
	
	return res;
}


- (void)onURLJSONObjectDownloadCompleted:(STSURLJSONObjectDownload *)d;
{
	if(!self.backendRequestDelegate)
		return;
	
	// d == self!
	
	if(d.succeeded)
	{
		if(d.object)
		{
			self.error = @"";
			[self onProcessObject:d.object];
		} else {
			self.succeeded = false;
			self.error = __trCtx(@"Server returned no result", @"BackendRequest");
		}
	} else {
		if((d.statusCode == 403) && (!m_bRetriedAfterAuthError))
		{
			// Access denied
			m_bRetriedAfterAuthError = true;
			if([[AuthManager instance] retryRequestAfterAuthentication:self])
			{
				m_bEnqueuedInAuthManager = true;
				return;
			}
		}
	}
	
	[self.backendRequestDelegate backendRequestCompleted:self];
}

@end
