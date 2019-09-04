//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSQLDataTypeInfo.h"

@implementation STSSQLDataTypeInfo
{
	STSSQLDataType m_eType;
	int m_iLength;
	int m_iFixedNumeridTotalDigits;
	int m_iFixedNumericDecimalDigits;
}

- (STSSQLDataType)type
{
	return m_eType;
}

- (void)setType:(STSSQLDataType)eType
{
	m_eType = eType;
}

- (int)length
{
	return m_iLength;
}

- (void)setLength:(int)iLen
{
	m_iLength = iLen;
}

- (int)fixedNumericTotalDigits
{
	return m_iFixedNumeridTotalDigits;
}

- (void)setFixedNumericTotalDigits:(int)iDigits
{
	m_iFixedNumeridTotalDigits = iDigits;
}

- (int)fixedNumericDecimalDigits
{
	return m_iFixedNumericDecimalDigits;
}

- (void)setFixedNumericDecimalDigits:(int)iDigits
{
	m_iFixedNumericDecimalDigits = iDigits;
}

@end
