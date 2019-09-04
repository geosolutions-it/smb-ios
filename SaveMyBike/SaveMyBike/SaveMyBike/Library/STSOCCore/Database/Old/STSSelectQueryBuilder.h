//
//  STSSelectQueryBuilder.h
//  
//  Created by Szymon Tomasz Stefanek on 2/25/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSDBConnection.h"

@interface STSSelectQueryBuilder : NSObject


- (id)initWithDatabase:(STSDBConnection *)pDb andBaseQuery:(NSString *)szSQL;

- (void)setSortOrder:(NSString *)szOrder;
- (void)setLimit:(int)iLimit;
- (void)addDoubleGreaterOrEqualConditionWithField:(NSString *)szField andValue:(double)val;
- (void)addDoubleGreaterConditionWithField:(NSString *)szField andValue:(double)val;
- (void)addDoubleLowerOrEqualConditionWithField:(NSString *)szField andValue:(double)val;
- (void)addDoubleLowerConditionWithField:(NSString *)szField andValue:(double)val;
- (void)addDoubleEqualConditionWithField:(NSString *)szField andValue:(double)val;
- (void)addLongGreaterOrEqualConditionWithField:(NSString *)szField andValue:(long)val;
- (void)addLongGreaterConditionWithField:(NSString *)szField andValue:(long)val;
- (void)addLongLowerOrEqualConditionWithField:(NSString *)szField andValue:(long)val;
- (void)addLongLowerConditionWithField:(NSString *)szField andValue:(long)val;
- (void)addLongEqualConditionWithField:(NSString *)szField andValue:(long)val;
- (void)addInConditionWithField:(NSString *)szField andValueList:(NSString *)szIn;
- (void)addStringEqualConditionWithField:(NSString *)szField andValue:(NSString *)szValue;
- (void)addStringLikeConditionWithField:(NSString *)szField andValue:(NSString *)szValue;
- (void)addStringInConditionWithField:(NSString *)szField andValueList:(NSArray<NSString *> *)pItems;
- (void)addTokenizedStringLikeConditionWithField:(NSString *)szField andString:(NSString *)szString;
- (void)addTokenizedStringLikeConditionWithField1:(NSString *)szField1 field2:(NSString *)szField2 andString:(NSString *)szString;
- (void)addTokenizedStringLikeConditionWithField1:(NSString *)szField1 field2:(NSString *)szField2 field3:(NSString *)szField3 andString:(NSString *)szString;

- (NSString *)build;


@end
