//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSSQLDataType.h"

@interface STSSQLDataTypeInfo : NSObject
{
}

- (STSSQLDataType)type;
- (void)setType:(STSSQLDataType)eType;
- (int)length;
- (void)setLength:(int)iLen;
- (int)fixedNumericTotalDigits;
- (void)setFixedNumericTotalDigits:(int)iDigits;
- (int)fixedNumericDecimalDigits;
- (void)setFixedNumericDecimalDigits:(int)iDigits;

@end
