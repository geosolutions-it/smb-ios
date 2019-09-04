//
//  STSImage+Histogram.m
//
//  Created by Szymon Tomasz Stefanek on 3/22/13.
//

#import "STSImage+Histogram.h"
#import "STSImage+Grayscale.h"

@implementation STSImage(Histogram)

- (STSImageHistogram *)computeHistogram
{
	return [self computeHistogramOnRect:[STSIRect rectWithX:0 y:0 width:m_uWidth height:m_uHeight]];
}

- (STSImageHistogram *)computeHistogramOnCGRect:(CGRect)rRect
{
	return [self computeHistogramOnRect:[STSIRect rectWithX:(int)rRect.origin.x y:(int)rRect.origin.y width:(int)rRect.size.width height:(int)rRect.size.height]];
}

- (STSImageHistogram *)computeHistogramOnRect:(STSIRect *)pRect
{
	if(!m_pBuffer)
		return NULL;
	
	STSImageHistogram * h = [[STSImageHistogram alloc] initWithChannels:m_uChannels];

	[pRect intersectWithX:0 y:0 width:m_uWidth height:m_uHeight];
	
	if([pRect isEmpty])
		return h;
	
	// FIXME: Unroll this for 3 and 4 channels?
	for(unsigned int c = 0;c < m_uChannels;c++)
	{
		unsigned int * hb = [h dataForChannel:c];
		
		unsigned char * s = m_pBuffer + c + ([pRect y] * m_uRowstride) + ([pRect x] * m_uChannels);
		unsigned char * e = s + (([pRect height] - 1) * m_uRowstride) + ([pRect width] * m_uChannels);
	
		while(s < e)
		{
			unsigned char * r = s;
			unsigned char * re = s + (m_uChannels * [pRect width]);
	
			while(r < re)
			{
				hb[*r]++;
				r += m_uChannels;
			}
			
			s += m_uRowstride;
		}
	}
	
	return h;
}

- (STSImageHistogram *)computeGrayscaleHistogram
{
	return [self computeGrayscaleHistogramOnRect:[STSIRect rectWithX:0 y:0 width:m_uWidth height:m_uHeight]];
}

- (STSImageHistogram *)computeGrayscaleHistogramOnCGRect:(CGRect)rRect
{
	return [self computeGrayscaleHistogramOnRect:[STSIRect rectWithX:(int)rRect.origin.x y:(int)rRect.origin.y width:(int)rRect.size.width height:(int)rRect.size.height]];
}

- (STSImageHistogram *)computeGrayscaleHistogramOnRect:(STSIRect *)pRect
{
	STSImage * pGray = [self convertToGrayscale];
	if(!pGray)
		return NULL;

	return [pGray computeHistogramOnRect:pRect];
}


- (void)equalizeHistogram
{
	STSImageHistogram * h = [self computeHistogram];

	if(!h)
		return; // doh

	[h transformToCumulativeDistributionAndNormalizeToMaximum:255];

	// FIXME: Unroll this for 3 and 4 channels?
	for(unsigned int c = 0;c < m_uChannels;c++)
	{
		unsigned int * hb = [h dataForChannel:c];
		
		unsigned char * s = m_pBuffer + c;
		unsigned char * e = s + (m_uHeight * m_uRowstride);
	
		while(s < e)
		{
			unsigned char * r = s;
			unsigned char * re = s + (m_uChannels * m_uWidth);
	
			while(r < re)
			{
				*r = hb[*r];
				r += m_uChannels;
			}
			
			s += m_uRowstride;
		}
	}

}

@end
