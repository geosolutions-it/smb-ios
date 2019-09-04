//
//  STSIRect.m
//
//  Created by Szymon Tomasz Stefanek on 22/03/2013.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSIRect.h"

@implementation STSIRect

@synthesize x = m_iX;
@synthesize y = m_iY;
@synthesize width = m_iW;
@synthesize height = m_iH;

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
		
	return self;
}

- (id)initWithX:(int)iX y:(int)iY width:(int)iWidth height:(int)iHeight
{
	self = [super init];
	if(!self)
		return nil;
	
	m_iX = iX;
	m_iY = iY;
	m_iW = iWidth;
	m_iH = iHeight;
	return self;
}

+ (STSIRect *)rectWithX:(int)iX y:(int)iY width:(int)iWidth height:(int)iHeight
{
	return [[STSIRect alloc] initWithX:iX y:iY width:iWidth height:iHeight];
}

- (void)intersectWithX:(int)iX y:(int)iY width:(int)iWidth height:(int)iHeight
{
	int r = m_iX + m_iW;
	int b = m_iY + m_iH;

	m_iX = MAX(m_iX,iX);
	m_iY = MAX(m_iY,iY);

	int tr = iX + iWidth;
	int tb = iY + iHeight;

	int rr = MIN(r,tr);
	int rb = MIN(b,tb);

	m_iW = rr - m_iX;
	m_iH = rb - m_iY;
}

- (bool)isEmpty
{
	return (m_iW <= 0) || (m_iH <= 0);
}

@end
