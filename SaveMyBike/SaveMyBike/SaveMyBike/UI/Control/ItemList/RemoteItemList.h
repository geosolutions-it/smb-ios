//
//  RemoteItemList.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "ItemList.h"

#import "BackendPagedRequest.h"

@class STSSimpleTableView;

@interface RemoteItemList : ItemList

- (id)init;

- (bool)refresh;

- (bool)startItemListFetchRequest;
- (void)stopItemListFetchRequest;

- (NSMutableArray< NSObject * > *)onGetItemsFromRequest:(BackendPagedRequest *)pRequest;
- (BackendPagedRequest *)onCreateRequest;

- (void)backendRequestCompleted:(BackendRequest *)pRequest;

@end

