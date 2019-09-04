//
//  NSString+URLEncoding.h
//
//  Created by Szymon Tomasz Stefanek on 25/11/12.
//  Copyright © 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(URLEncoding)

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

@end
