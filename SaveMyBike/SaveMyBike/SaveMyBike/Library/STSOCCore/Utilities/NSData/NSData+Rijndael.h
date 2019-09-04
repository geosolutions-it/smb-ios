//
//  NSData+Rijndael.h
//
//  Created by Szymon Tomasz Stefanek on 25/11/12.
//  Copyright © 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(Rijndael)

- (NSData *)encryptWithRijndaelAnd32ByteKey:(NSString *)key;
- (NSData *)decryptWithRijndaelAnd32ByteKey:(NSString *)key;

@end
