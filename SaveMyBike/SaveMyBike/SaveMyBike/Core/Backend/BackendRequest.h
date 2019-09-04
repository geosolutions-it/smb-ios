//
//  Created by Szymon Tomasz Stefanek on 02/06/19.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "STSURLJSONObjectDownload.h"

#import "JSONConvertible.h"

@class BackendRequest;

@protocol BackendRequestDelegate

- (void)backendRequestCompleted:(BackendRequest *)pRequest;

@end

@interface BackendRequest : STSURLJSONObjectDownload<STSURLJSONObjectDownloadDelegate>

@property(nonatomic,weak) id<BackendRequestDelegate> backendRequestDelegate;

- (void)onProcessObject:(id)ob;

- (id<JSONConvertible>)decodeObject:(id)ob intoResult:(id<JSONConvertible>)res;

// For AuthManager
- (bool)_restartAfterAuth;
- (void)_failWithError:(NSString *)sError;

@end
