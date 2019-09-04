//
//  Created by Szymon Tomasz Stefanek on 04/06/2019.
//  Copyright © 2019 Szymon Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BackendRequest;

typedef enum _AuthManagerState
{
	AuthManagerStateNotConfigured,
	AuthManagerStateDiscoveringService,
	AuthManagerStateDiscoveryFailed,
	AuthManagerStateError,
	AuthManagerStateIdle,
	AuthManagerStateRefreshingTokens,
	AuthManagerStateLoggingOut,
	AuthManagerStateLoggingIn,
	AuthManagerStateLoggedIn
} AuthManagerState;

@protocol AuthManagerStateObserver<NSObject>

- (void)onAuthManagerStateChanged;

@end

@interface AuthManager : NSObject

+ (void)create;
+ (void)destroy;

+ (AuthManager *)instance;

- (NSString *)error;
- (AuthManagerState)state;

- (bool)haveValidAuthState;
- (void)startLogoutRequest;

- (void)addStateObserver:(__weak id<AuthManagerStateObserver>)pObserver;
- (void)removeStateObserver:(__weak id<AuthManagerStateObserver>)pObserver;

- (void)startServiceDiscovery;
- (bool)handleOpenURL:(NSURL *)oURL;

- (void)startAuthRequest;

- (void)startAuthStateCheck;

- (bool)retryRequestAfterAuthentication:(BackendRequest *)r;
- (void)dequeueRequest:(BackendRequest *)r;

@end

