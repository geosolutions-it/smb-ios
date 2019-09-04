//
//  STSImageHistogram.m
//
//  Created by Szymon Tomasz Stefanek on 3/22/13.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSImageHistogram.h"

@implementation STSImageHistogram

@synthesize channels = m_uChannels;

- (id)initWithChannels:(unsigned int)uChannels
{
	self = [super init];
	if(!self)
		return nil;
	m_uChannels = uChannels;
	if(m_uChannels == 0)
	{
		m_pBuffer = NULL;
	} else {
		unsigned int uSize = m_uChannels * 256;
		m_pBuffer = (unsigned int *)malloc(uSize * sizeof(unsigned int));
		unsigned int * p = m_pBuffer;
		unsigned int * e = m_pBuffer + uSize;
		while(p < e)
			*p++ = 0;
	}
	
	return self;
}

- (void)dealloc
{
	if(m_pBuffer)
	{
		free(m_pBuffer);
		m_pBuffer = NULL;
	}
}

- (void)clear
{
	if(!m_pBuffer)
		return;
	unsigned int uSize = m_uChannels * 256;
	unsigned int * p = m_pBuffer;
	unsigned int * e = m_pBuffer + uSize;
	while(p < e)
		*p++ = 0;
}

-(unsigned int *)dataForChannel:(unsigned int)uChannelIndex
{
	if(!m_pBuffer)
		return NULL;
	if(uChannelIndex >= m_uChannels)
		return NULL;
	return m_pBuffer + (uChannelIndex * 256);
}

- (void)transformToCumulativeDistribution
{
	if(!m_pBuffer)
		return;

	unsigned int uSize = m_uChannels * 256;
	unsigned int * p = m_pBuffer;
	unsigned int * e = m_pBuffer + uSize;
	while(p < e)
	{
		unsigned int * pp = p;
		unsigned int * pe = p + 256;
		unsigned int uSum = 0;
		while(pp < pe)
		{
			unsigned int uSave = *pp;
			*pp = uSum; // maps the lowest value to 0
			uSum += uSave;
			pp++;
		}
		p += 256;
	}
}

- (void)transformToCumulativeDistributionAndNormalizeToMaximum:(unsigned int)uMaximum
{
	if(!m_pBuffer)
		return;

	unsigned int uSize = m_uChannels * 256;
	unsigned int * p = m_pBuffer;
	unsigned int * e = m_pBuffer + uSize;
	while(p < e)
	{
		unsigned int * pp = p;
		unsigned int * pe = p + 256;
		unsigned int uSum = 0;
		unsigned int uSave = 0;
		while(pp < pe)
		{
			uSave = *pp;
			*pp = uSum; // maps the lowest value to 0
			uSum += uSave;
			pp++;
		}
		// normalize
		
		pp = p;
		uSum -= uSave; // remove the last part
		if(uSum > 0)
		{
			// uSum : 255 = uValue : x -- x = uValue * uMaximum / uSum
			double fScale = (double)uMaximum / (double)uSum;
			while(pp < pe)
			{
				*pp = (unsigned int)(((double)*pp) * fScale);
				if(*pp > uMaximum)
					*pp = uMaximum;
				pp++;
			}
		}
		
		p += 256;
	}
}

@end
