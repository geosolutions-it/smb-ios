//
//  Created by Szymon Tomasz Stefanek on 04/06/2019.
//  Copyright © 2019 Szymon Stefanek. All rights reserved.
//

#import "AuthManager.h"

#import "AppAuth.h"
#import "Config.h"
#import "TopLevelViewController.h"
#import "STSCore.h"
#import "Globals.h"
#import "STSDelegateArray.h"
#import "BackendRequest.h"

static AuthManager * g_pAuthManager = nil;

@interface AuthManager()
{
	OIDServiceConfiguration * m_pConfiguration;
	id<OIDExternalUserAgentSession> m_pCurrentAuthorizationFlow;
	OIDAuthState * m_pAuthState;
	STSDelegateArray * m_pStateObservers;
	AuthManagerState m_eState;
	NSString * m_sError;
	NSMutableArray<BackendRequest *> * m_pRequestsQueuedForAuthentication;
}
@end

@implementation AuthManager

- (void)initialize
{
	m_pStateObservers = [STSDelegateArray new];
	m_eState = AuthManagerStateNotConfigured;
	m_pRequestsQueuedForAuthentication = [NSMutableArray new];
}

- (void)cleanup
{
	[self failAllPendingRequests:@"Cleaning up"];
	[m_pStateObservers removeAllDelegates];
	m_pStateObservers = nil;
}

+ (void)create
{
	g_pAuthManager = [AuthManager new];
	[g_pAuthManager initialize];
	[g_pAuthManager loadState];
}

+ (void)destroy
{
	if(g_pAuthManager)
		[g_pAuthManager cleanup];
	g_pAuthManager = nil;
}

+ (AuthManager *)instance
{
	return g_pAuthManager;
}

- (void)addStateObserver:(__weak id<AuthManagerStateObserver>)pObserver
{
	[m_pStateObservers addDelegate:pObserver];
}

- (void)removeStateObserver:(__weak id<AuthManagerStateObserver>)pObserver
{
	[m_pStateObservers removeDelegate:pObserver];
}

- (void)failAllPendingRequests:(NSString *)sError
{
	while(m_pRequestsQueuedForAuthentication.count > 0)
	{
		BackendRequest * r = [m_pRequestsQueuedForAuthentication objectAtIndex:0];
		[m_pRequestsQueuedForAuthentication removeObjectAtIndex:0];
		[r _failWithError:sError];
	}
}

- (void)startAllPendingRequests
{
	while(m_pRequestsQueuedForAuthentication.count > 0)
	{
		BackendRequest * r = [m_pRequestsQueuedForAuthentication objectAtIndex:0];
		[m_pRequestsQueuedForAuthentication removeObjectAtIndex:0];
		[r _restartAfterAuth];
	}
}

- (bool)retryRequestAfterAuthentication:(BackendRequest *)r
{
	switch(m_eState)
	{
		case AuthManagerStateIdle:
		case AuthManagerStateError:
		case AuthManagerStateLoggedIn:
			[m_pRequestsQueuedForAuthentication addObject:r];
			if(m_pAuthState)
				[self startAuthStateCheck];
			else
				[self startAuthRequest];
		break;
		case AuthManagerStateLoggingIn:
		case AuthManagerStateRefreshingTokens:
		case AuthManagerStateDiscoveringService:
			[m_pRequestsQueuedForAuthentication addObject:r];
		break;
		//case AuthManagerStateNotConfigured:
		//case AuthManagerStateDiscoveryFailed:
		default:
			return false;
		break;
	}
	
	return true;
}

- (void)dequeueRequest:(BackendRequest *)r
{
	[m_pRequestsQueuedForAuthentication removeObject:r];
}

- (void)_setState:(AuthManagerState)eState
{
	if(m_eState == eState)
		return;
	m_eState = eState;
	if(m_pStateObservers.count > 0)
		[m_pStateObservers performSelectorOnAllDelegates:@selector(onAuthManagerStateChanged)];
}

- (AuthManagerState)state
{
	return m_eState;
}

- (NSString *)error
{
	return m_sError;
}

- (void)saveState
{
	if(m_pAuthState)
	{
		NSData *archivedAuthState = [NSKeyedArchiver archivedDataWithRootObject:m_pAuthState];
		[[NSUserDefaults standardUserDefaults] setObject:archivedAuthState forKey:@"auth-state"];
	} else {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"auth-state"];
	}

	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadState
{
	NSData *archivedAuthState = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth-state"];
	m_pAuthState = [NSKeyedUnarchiver unarchiveObjectWithData:archivedAuthState];
	if(![m_pAuthState isAuthorized])
	{
		// FIXME: Can happen?
		m_pAuthState = nil;
	}
}

- (bool)handleOpenURL:(NSURL *)oURL
{
	if(!m_pCurrentAuthorizationFlow)
	{
		// FIXME: What here?
		return false; // AARGH!
	}
	if([m_pCurrentAuthorizationFlow resumeExternalUserAgentFlowWithURL:oURL])
	{
		m_pCurrentAuthorizationFlow = nil;
		return true;
	}
	return false;
}

- (void)onServiceDiscoveryFailed:(NSString *)sError
{
	STS_CORE_LOG(@"WARNING: Service discovery failed: %@",sError);
	m_sError = sError;
	[self _setState:AuthManagerStateDiscoveryFailed];
}

- (void)onServiceDiscoverySucceeded:(OIDServiceConfiguration *)cfg
{
	STS_CORE_LOG(@"Service discovery succeeded");
	m_pConfiguration = cfg;
	[self _setState:AuthManagerStateIdle];
}

- (void)startServiceDiscovery
{
	STS_CORE_LOG(@"Starting service discovery");

	if(m_eState != AuthManagerStateNotConfigured)
	{
		STS_CORE_LOG(@"WARNING: Called when already configured");
	}

	[self _setState:AuthManagerStateDiscoveringService];
	
	NSURL * oURL = [NSURL URLWithString:SMB_AUTH_DISCOVERY_URL];
	
	AuthManager * that = self;
	
	[OIDAuthorizationService
	 			discoverServiceConfigurationForDiscoveryURL:oURL
				completion:^(OIDServiceConfiguration *_Nullable configuration,NSError *_Nullable error)
				{
					if (!configuration)
					{
						[that onServiceDiscoveryFailed:[error localizedDescription]];
						return;
					}
		 
					[that onServiceDiscoverySucceeded:configuration];
				}
		];
}

- (bool)haveValidAuthState
{
	return m_pAuthState;
}

- (void)onAuthRequestFailed:(NSString *)sError
{
	STS_CORE_LOG(@"WARNING: Auth request failed: %@",sError);

	m_sError = sError;
	[self _setState:AuthManagerStateError];
	[self failAllPendingRequests:sError];
}

- (void)onAuthRequestSucceeded:(OIDAuthState *)pState
{
	STS_CORE_LOG(@"Auth request succeeded [toen=%@]",pState.lastTokenResponse.accessToken);

	m_pAuthState = pState;
	[self saveState];
	[Globals instance].authToken = pState.lastTokenResponse.accessToken;
	[self _setState:AuthManagerStateLoggedIn];
	[self startAllPendingRequests];
}

- (void)startAuthRequest
{
	STS_CORE_LOG(@"Starting auth request");

	OIDAuthorizationRequest *request = [[OIDAuthorizationRequest alloc]
							initWithConfiguration:m_pConfiguration
							clientId:SMB_AUTH_CLIENT_ID
							scopes:@[OIDScopeOpenID,OIDScopeEmail,OIDScopeProfile]
							redirectURL:[NSURL URLWithString:SMB_AUTH_REDIRECT_URI]
							responseType:OIDResponseTypeCode
							additionalParameters:nil
		];
	
	AuthManager * that = self;
	
	m_pCurrentAuthorizationFlow = [OIDAuthState
				authStateByPresentingAuthorizationRequest:request
				presentingViewController:[TopLevelViewController instance]
				callback:^(OIDAuthState *_Nullable authState,NSError *_Nullable error)
				{
					if(!authState)
					{
						[that onAuthRequestFailed:[error localizedDescription]];
						return;
					}
					
					[that onAuthRequestSucceeded:authState];
				}
			];
}

- (void)startAuthStateCheck
{
	STS_CORE_LOG(@"Starting auth state check");

	[self _setState:AuthManagerStateRefreshingTokens];
	[m_pAuthState performActionWithFreshTokens:^(NSString * _Nullable accessToken, NSString * _Nullable idToken, NSError * _Nullable error) {
		if(accessToken != nil)
		{
			[self saveState];
			[Globals instance].authToken = accessToken;
			[self _setState:AuthManagerStateLoggedIn];
			[self startAllPendingRequests];
		} else {
			m_pAuthState = nil;
			[self saveState];
			m_sError = [error localizedDescription];
			// FIXME: Go to login?
			if(m_sError && [m_sError containsString:@"xpired"])
				[self _setState:AuthManagerStateIdle]; // assume no error: authentication just expired
			else
				[self _setState:AuthManagerStateError];
			[self failAllPendingRequests:m_sError];
		}
	}];
}

- (void)startLogoutRequest
{
	if((!m_pAuthState) || (!m_pConfiguration) || (![Globals instance].authToken))
		return;

	AuthManager * that = self;

	OIDEndSessionRequest * rq = [[OIDEndSessionRequest alloc]
			 initWithConfiguration:m_pConfiguration
				 idTokenHint:[Globals instance].authToken
				 postLogoutRedirectURL:[NSURL URLWithString:SMB_AUTH_REDIRECT_URI]
				 additionalParameters:nil
		];
	
	OIDExternalUserAgentIOS * pAgent = [[OIDExternalUserAgentIOS alloc] initWithPresentingViewController:[TopLevelViewController instance]];
	
	m_pCurrentAuthorizationFlow = [OIDAuthorizationService
						presentEndSessionRequest:rq
								   externalUserAgent:pAgent
								   callback:^(OIDEndSessionResponse * _Nullable endSessionResponse, NSError * _Nullable error)
	{
		if(endSessionResponse)
			[that onLogoutSucceeded];
		else
			[that onLogoutFailed:[error localizedDescription]];
	}];

	// Immediately drop auth state so we don't return to homepage
	m_pAuthState = nil;
	[Globals instance].authToken = nil;
	[self saveState];
}

- (void)clearCookies
{
	STS_CORE_LOG(@"Clearing cookies....");

	NSHTTPCookieStorage * st = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	if(!st)
		return;

	if(!st.cookies)
		return;

	if(st.cookies.count < 1)
		return;

	STS_CORE_LOG(@"There are %d cookies to clear",(int)st.cookies.count);

	for(NSHTTPCookie * c in st.cookies)
		[st deleteCookie:c];
}

- (void)onLogoutSucceeded
{
	STS_CORE_LOG(@"Logout request succeeded");

	m_pCurrentAuthorizationFlow = nil;
	m_pAuthState = nil;
	[Globals instance].authToken = nil;
	[self saveState];
	[self _setState:AuthManagerStateIdle];
	[self clearCookies];
}

- (void)onLogoutFailed:(NSString *)sError
{
	STS_CORE_LOG(@"Logout request failed: %@",sError);
	m_sError = sError;
}

@end
