//
//  JSONConvertible.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#ifndef JSONConvertible_h
#define JSONConvertible_h

#import <Foundation/Foundation.h>

@protocol JSONConvertible<NSObject>

- (NSString *)decodeJSON:(id)x;
- (NSString *)decodeJSONString:(NSString *)szJSON;
- (NSString *)decodeJSONData:(NSData *)oJSON;
- (NSMutableDictionary *)encodeToJSON;
- (NSString *)encodeToJSONString;
- (NSData *)encodeToJSONData;

@end

#endif /* JSONConvertible_h */
