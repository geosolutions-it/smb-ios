//
//  BackendPagedRequest.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequest.h"


@interface BackendPagedRequest : BackendRequest

@property(nonatomic) int page;
@property(nonatomic) int page_size;

@property(nonatomic) int count;
@property(nonatomic) NSString * prev;
@property(nonatomic) NSString * next;

- (NSMutableArray<id<JSONConvertible>> *)decodePagedResult:(id)ob arrayMember:(NSString *)sArrayMember itemClass:(Class)oClass;

@end

