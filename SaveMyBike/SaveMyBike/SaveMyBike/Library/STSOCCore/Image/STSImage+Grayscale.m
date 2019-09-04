//
//  STSImage+Grayscale.m
//
//  Created by Szymon Tomasz Stefanek on 3/29/13.
//

#import "STSImage+Grayscale.h"

@implementation STSImage(Grayscale)

- (STSImage *)convertToGrayscale;
{
	if(!m_pBuffer)
		return nil;
	
	STSImage * pDest = [[STSImage alloc] initWithWidth:m_uWidth height:m_uHeight channels:1];
	
	unsigned char * d = pDest.buffer;
	
	unsigned char * s = m_pBuffer;
	unsigned char * e = m_pBuffer + (m_uRowstride * m_uHeight);
	
	if(m_uChannels < 2)
	{
		memcpy(d,s,e - s);
		return pDest;
	}
	
	while(s < e)
	{
		unsigned char * sr = s;
		unsigned char * sre = s + (m_uWidth * m_uChannels);
	
		switch(m_uChannels)
		{
			case 2:
				while(sr < sre)
				{
					unsigned int u = *sr++;
					u += *sr++;
					
					*d++ = (unsigned char)(u / 2);
				}
			break;
			case 3:
				while(sr < sre)
				{
					unsigned int u = *sr++;
					u += *sr++;
					u += *sr++;
					
					*d++ = (unsigned char)(u / 3);
				}
			break;
			case 4:
				while(sr < sre)
				{
					unsigned int u = *sr++;
					u += *sr++;
					u += *sr;
					sr+=2;
					
					*d++ = (unsigned char)(u / 3);
				}
			break;
			default:
				while(sr < sre)
				{
					unsigned int u = *sr++;
					for(unsigned int x = 1;x < m_uChannels;x++)
						u += *sr++;
					
					*d++ = (unsigned char)(u / m_uChannels);
				}
			break;
		}
		
		
		s += m_uRowstride;
	}
	
	return pDest;
}


@end
