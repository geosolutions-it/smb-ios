//
//  STSSelectQueryBuilder.m 
//
//  Created by Szymon Tomasz Stefanek on 2/25/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSelectQueryBuilder.h"

#import "STSDBConnection.h"
#import "NSString+Manipulation.h"

@implementation STSSelectQueryBuilder
{
	STSDBConnection * m_pDb;
	NSString * m_szBaseQuery;
	NSMutableArray<NSString *> * m_pConditions;
	NSString * m_szSortOrder;
	int m_iLimit;
}

- (id)initWithDatabase:(STSDBConnection *)pDb andBaseQuery:(NSString *)szSQL
{
	self = [super init];
	if(!self)
		return nil;
	
	m_pDb = pDb;
	m_szBaseQuery = szSQL;
	m_pConditions = [NSMutableArray new];
	
	return self;
}

- (void)setSortOrder:(NSString *)szOrder
{
	m_szSortOrder = szOrder;
}

- (void)setLimit:(int)iLimit
{
	m_iLimit = iLimit;
}

- (void)addDoubleGreaterOrEqualConditionWithField:(NSString *)szField andValue:(double)val
{
	[m_pConditions addObject:[NSString stringWithFormat:@"%@ >= %f",szField,val]];
}

- (void)addDoubleGreaterConditionWithField:(NSString *)szField andValue:(double)val
{
	[m_pConditions addObject:[NSString stringWithFormat:@"%@ > %f",szField,val]];
}

- (void)addDoubleLowerOrEqualConditionWithField:(NSString *)szField andValue:(double)val
{
	[m_pConditions addObject:[NSString stringWithFormat:@"%@ <= %f",szField,val]];
}

- (void)addDoubleLowerConditionWithField:(NSString *)szField andValue:(double)val
{
	[m_pConditions addObject:[NSString stringWithFormat:@"%@ < %f",szField,val]];
}

- (void)addDoubleEqualConditionWithField:(NSString *)szField andValue:(double)val
{
	[m_pConditions addObject:[NSString stringWithFormat:@"%@ = %f",szField,val]];
}



- (void)addLongGreaterOrEqualConditionWithField:(NSString *)szField andValue:(long)val
{
	[m_pConditions addObject:[NSString stringWithFormat:@"%@ >= %ld",szField,val]];
}

- (void)addLongGreaterConditionWithField:(NSString *)szField andValue:(long)val
{
	[m_pConditions addObject:[NSString stringWithFormat:@"%@ > %ld",szField,val]];
}

- (void)addLongLowerOrEqualConditionWithField:(NSString *)szField andValue:(long)val
{
	[m_pConditions addObject:[NSString stringWithFormat:@"%@ <= %ld",szField,val]];
}

- (void)addLongLowerConditionWithField:(NSString *)szField andValue:(long)val
{
	[m_pConditions addObject:[NSString stringWithFormat:@"%@ < %ld",szField,val]];
}

- (void)addLongEqualConditionWithField:(NSString *)szField andValue:(long)val
{
	[m_pConditions addObject:[NSString stringWithFormat:@"%@ = %ld",szField,val]];
}

- (void)addInConditionWithField:(NSString *)szField andValueList:(NSString *)szIn
{
	if([NSString isNullOrEmpty:szIn])
		szIn = @"";
	[m_pConditions addObject:[NSString stringWithFormat:@"%@ in %@",szField,szIn]];
}

- (void)addStringEqualConditionWithField:(NSString *)szField andValue:(NSString *)szValue
{
	if([NSString isNullOrEmpty:szValue])
		szValue = @"";
	[m_pConditions addObject:[NSString stringWithFormat:@"%@ = '%@'",szField,[m_pDb quote:szValue]]];
}

- (void)addStringLikeConditionWithField:(NSString *)szField andValue:(NSString *)szValue
{
	if([NSString isNullOrEmpty:szValue])
		szValue = @"";
	[m_pConditions addObject:[NSString stringWithFormat:@"%@ like '%%%@%%'",szField,[m_pDb quote:szValue]]];
}

- (void)addStringInConditionWithField:(NSString *)szField andValueList:(NSArray<NSString *> *)pItems
{
	if(!pItems)
		return;
	NSString * s = nil;
	for(NSString * x in pItems)
	{
		if(!s)
			s = [NSString stringWithFormat:@"'%@'",[m_pDb quote:x]];
		else
			s = [s stringByAppendingString:[NSString stringWithFormat:@",'%@'",[m_pDb quote:x]]];
	}
	if(!s)
		return;
	[m_pConditions addObject:[NSString stringWithFormat:@"%@ in (%@)",szField,s]];
}

- (void)addTokenizedStringLikeConditionWithField:(NSString *)szField andString:(NSString *)szString
{
	if([NSString isNullOrEmpty:szString])
		szString = @"";
	
	NSArray * a = [szString componentsSeparatedByString:@" "];
	if(!a)
		return;
	
	NSString * szSql = nil;
	
	for(NSString * s in a)
	{
		NSString * t = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		if([NSString isNullOrEmpty:t])
			continue;
		if(szSql)
			szSql = [szSql stringByAppendingString:@" and "];
		else
			szSql = @"";
		szSql = [szSql stringByAppendingString:[NSString stringWithFormat:@"(%@ like '%%%@%%')",szField,[m_pDb quote:t]]];
	}
	
	if(!szSql)
		return;
	
	[m_pConditions addObject:szSql];
}

- (void)addTokenizedStringLikeConditionWithField1:(NSString *)szField1 field2:(NSString *)szField2 andString:(NSString *)szString
{
	if([NSString isNullOrEmpty:szString])
		szString = @"";
	
	NSArray * a = [szString componentsSeparatedByString:@" "];
	if(!a)
		return;
	
	NSString * szSql = nil;
	
	for(NSString * s in a)
	{
		NSString * t = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		if([NSString isNullOrEmpty:t])
			continue;
		if(szSql)
			szSql = [szSql stringByAppendingString:@" and "];
		else
			szSql = @"";
		szSql = [szSql stringByAppendingString:[NSString stringWithFormat:@"((%@ like '%%%@%%')",szField1,[m_pDb quote:t]]];
		szSql = [szSql stringByAppendingString:@" or "];
		szSql = [szSql stringByAppendingString:[NSString stringWithFormat:@"(%@ like '%%%@%%'))",szField2,[m_pDb quote:t]]];
	}
	
	if(!szSql)
		return;
	
	[m_pConditions addObject:szSql];
}

- (void)addTokenizedStringLikeConditionWithField1:(NSString *)szField1 field2:(NSString *)szField2 field3:(NSString *)szField3 andString:(NSString *)szString
{
	if([NSString isNullOrEmpty:szString])
		szString = @"";
	
	NSArray * a = [szString componentsSeparatedByString:@" "];
	if(!a)
		return;
	
	NSString * szSql = nil;
	
	for(NSString * s in a)
	{
		NSString * t = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		if([NSString isNullOrEmpty:t])
			continue;
		if(szSql)
			szSql = [szSql stringByAppendingString:@" and "];
		else
			szSql = @"";
		szSql = [szSql stringByAppendingString:[NSString stringWithFormat:@"((%@ like '%%%@%%')",szField1,[m_pDb quote:t]]];
		szSql = [szSql stringByAppendingString:@" or "];
		szSql = [szSql stringByAppendingString:[NSString stringWithFormat:@"(%@ like '%%%@%%')",szField2,[m_pDb quote:t]]];
		szSql = [szSql stringByAppendingString:@" or "];
		szSql = [szSql stringByAppendingString:[NSString stringWithFormat:@"(%@ like '%%%@%%'))",szField3,[m_pDb quote:t]]];
	}
	
	if(!szSql)
		return;

	[m_pConditions addObject:szSql];
}

- (NSString *)build
{
	NSString * s = m_szBaseQuery;
	
	if(m_pConditions.count > 0)
	{
		NSString * c = nil;
		for(NSString * x in m_pConditions)
		{
			if(c)
				c = [c stringByAppendingString:@" and "];
			else
				c = @"";
			c = [c stringByAppendingString:[NSString stringWithFormat:@"(%@)",x]];
		}
		
		if(c)
			s = [s stringByAppendingString:[NSString stringWithFormat:@" where %@",c]];
	}
	
	if(![NSString isNullOrEmpty:m_szSortOrder])
		s = [s stringByAppendingString:[NSString stringWithFormat:@" order by %@",m_szSortOrder]];
	
	if(m_iLimit > 0)
		s = [s stringByAppendingString:[NSString stringWithFormat:@" limit %d",m_iLimit]];
	
	return s;
}

@end
