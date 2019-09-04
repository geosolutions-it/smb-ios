//
// STSImage.m
//
// Created by Szymon Tomasz Stefanek on 22/03/2013
// Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSImage.h"


@implementation STSImage

@synthesize width = m_uWidth;
@synthesize height = m_uHeight;
@synthesize channels = m_uChannels;
@synthesize rowstride = m_uRowstride;

#define SETSTS_NULL_IMAGE \
	do { \
		m_pBuffer = NULL; \
		m_uWidth = 0; \
		m_uHeight = 0; \
		m_uChannels = 0; \
		m_uRowstride = 0; \
	} while(0)

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	SETSTS_NULL_IMAGE;
	return self;
}

- (id)initWithUIImage:(UIImage *)pImage
{
	self = [super init];
	if(!self)
		return nil;

	if(!pImage)
	{
		SETSTS_NULL_IMAGE;
		return self;
	}

	CGImageRef imageRef = [pImage CGImage];

	m_uWidth = (unsigned int)CGImageGetWidth(imageRef);
	m_uHeight = (unsigned int)CGImageGetHeight(imageRef);
	
	CGDataProviderRef hDataProvider = CGImageGetDataProvider(imageRef);
	if(!hDataProvider)
	{
		SETSTS_NULL_IMAGE;
		return self;
	}
	
	CFDataRef hData = CGDataProviderCopyData(hDataProvider);
	if(!hData)
	{
		SETSTS_NULL_IMAGE;
		return self;
	}
	
	const UInt8 * s = CFDataGetBytePtr(hData);
	if(!s)
	{
		CFRelease(hData);
		SETSTS_NULL_IMAGE;
		return self;
	}

	unsigned int uBitsPerPixel = (unsigned int)CGImageGetBitsPerPixel(imageRef);
	CGImageAlphaInfo eAlphaInfo = CGImageGetAlphaInfo(imageRef);
	unsigned int uBitsPerComponent = (unsigned int)CGImageGetBitsPerComponent(imageRef);
	unsigned int uBytesPerRow = (unsigned int)CGImageGetBytesPerRow(imageRef);
	
    
    
	if(uBitsPerComponent != 8)
	{
		// unsupported (for now)
		CFRelease(hData);
		SETSTS_NULL_IMAGE;
		return self;
	}
	
	unsigned int uSourceChannels;
	
	switch(uBitsPerPixel)
	{
		case 24:
			uSourceChannels = 3;
			m_uChannels = 3; // assume there are 3 valid bytes per pixel
		break;
		case 32:
			uSourceChannels = 4;
			switch(eAlphaInfo)
			{
				case kCGImageAlphaFirst:
				case kCGImageAlphaLast:
				case kCGImageAlphaPremultipliedFirst:
				case kCGImageAlphaPremultipliedLast:
					m_uChannels = 4;
				break;
				default:
					// assume that there is no alpha or it's skipped
					m_uChannels = 4;
				break;
			}
		break;
		case 8:
			uSourceChannels = 1;
			m_uChannels = 1;
		break;
		case 16:
			uSourceChannels = 2;
			m_uChannels = 1;
		break;
		default:
			CFRelease(hData);
			SETSTS_NULL_IMAGE;
			return self;
		break;
	}
	
	// FIXME: Align to 16 byte boundary? (as the Apple documentation suggests)
	m_uRowstride = m_uWidth * m_uChannels;
	
	unsigned int uBufferSize = m_uHeight * m_uRowstride;
	if(uBufferSize == 0)
	{
		CFRelease(hData);
		SETSTS_NULL_IMAGE;
		return self;
	}

	m_pBuffer = (unsigned char *)malloc(uBufferSize);

	unsigned char * d = m_pBuffer;
	unsigned char * e = m_pBuffer + uBufferSize;
	
	switch(m_uChannels)
	{
		case 1:
			switch(uSourceChannels)
			{
				case 1:
					if(uBytesPerRow == m_uRowstride)
					{
						memcpy(d,s,uBufferSize);
					} else {
						while(d < e)
						{
							memcpy(d,s,m_uRowstride);
							d += m_uRowstride;
							s += uBytesPerRow;
						}
					}
				break;
				case 2:
					if(uBytesPerRow == (m_uRowstride * 2))
					{
						while(d < e)
						{
							*d++ = *s;
							s += 2;
						}
					} else {
						while(d < e)
						{
							unsigned char * rd = d;
							unsigned char * re = d + m_uRowstride;
							const unsigned char * sd = s;
							while(rd < re)
							{
								*rd++ = *sd;
								sd += 2;
							}
							d = re;
							s += uBytesPerRow;
						}
					}
				break;
				default:
					free(m_pBuffer);
					CFRelease(hData);
					SETSTS_NULL_IMAGE;
					return self;
				break;
			}
		break;
		case 3:
			switch(uSourceChannels)
			{
				case 1:
					if(m_uRowstride == (uBytesPerRow * 3))
					{
						while(d < e)
						{
							*d++ = *s;
							*d++ = *s;
							*d++ = *s++;
						}
					} else {
						while(d < e)
						{
							unsigned char * rd = d;
							unsigned char * re = d + m_uRowstride;
							const unsigned char * sd = s;
							while(rd < re)
							{
								*rd++ = *sd;
								*rd++ = *sd;
								*rd++ = *sd++;
							}
							d = re;
							s += uBytesPerRow;
						}
					}
				break;
				case 3:
					if(uBytesPerRow == m_uRowstride)
					{
						memcpy(d,s,uBufferSize);
					} else {
						while(d < e)
						{
							memcpy(d,s,m_uRowstride);
							d += m_uRowstride;
							s += uBytesPerRow;
						}
					}
				break;
				case 4:
					switch(eAlphaInfo)
					{
						case kCGImageAlphaNoneSkipFirst:
							while(d < e)
							{
								unsigned char * rd = d;
								unsigned char * re = d + m_uRowstride;
								const unsigned char * sd = s;
								while(rd < re)
								{
									sd++;
									*rd++ = *sd++;
									*rd++ = *sd++;
									*rd++ = *sd++;
								}
								d = re;
								s += uBytesPerRow;
							}
						break;
						case kCGImageAlphaNoneSkipLast:
						case kCGImageAlphaLast:
						case kCGImageAlphaNone:
							while(d < e)
							{
								unsigned char * rd = d;
								unsigned char * re = d + m_uRowstride;
								const unsigned char * sd = s;
								while(rd < re)
								{
									*rd++ = *sd++;
									*rd++ = *sd++;
									*rd++ = *sd++;
									sd++;
								}
								d = re;
								s += uBytesPerRow;
							}
						break;
						default:
							free(m_pBuffer);
							CFRelease(hData);
							SETSTS_NULL_IMAGE;
							return self;
						break;
					}
				break;
				default:
					free(m_pBuffer);
					CFRelease(hData);
					SETSTS_NULL_IMAGE;
					return self;
				break;
			}
		break;
		case 4:
			switch(uSourceChannels)
			{
				case 1:
					if(m_uRowstride == (uBytesPerRow * 4))
					{
						while(d < e)
						{
							*d++ = *s;
							*d++ = *s;
							*d++ = *s;
							*d++ = *s++;
						}
					} else {
						while(d < e)
						{
							unsigned char * rd = d;
							unsigned char * re = d + m_uRowstride;
							const unsigned char * sd = s;
							while(rd < re)
							{
								*rd++ = *sd;
								*rd++ = *sd;
								*rd++ = *sd;
								*rd++ = *sd++;
							}
							d = re;
							s += uBytesPerRow;
						}
					}
				break;
                case 3:
                    while(d < e)
                    {
                        unsigned char * rd = d;
                        unsigned char * re = d + m_uRowstride;
                        const unsigned char * sd = s;
                        while(rd < re)
                        {
                            *rd++ = *sd++;
                            *rd++ = *sd++;
                            *rd++ = *sd++;
                            rd++;
                        }
                        d = re;
                        s += uBytesPerRow;
                    }
                break;
				case 4:
					switch(eAlphaInfo)
					{
						case kCGImageAlphaPremultipliedLast:
						case kCGImageAlphaPremultipliedFirst:
						{
							while(d < e)
							{
								unsigned char * rd = d;
								unsigned char * re = d + m_uRowstride;
								const unsigned char * sd = s;
								while(rd < re)
								{
									unsigned char a = sd[3];
									if(a == 255)
									{
										*((UInt32 *)rd) = *((const UInt32 *)sd);
										rd += 4;
										sd += 4;
									} else if(a == 0)
									{
										*((UInt32 *)rd) = 0;
										rd += 4;
										sd += 4;
									} else {
										*rd++ = (*sd++ * 255) / a;
										*rd++ = (*sd++ * 255) / a;
										*rd++ = (*sd++ * 255) / a;
										*rd++ = a;
										sd++;
									}
								}
								d = re;
								s += uBytesPerRow;
							}
						}
						break;
/*
						case kCGImageAlphaPremultipliedLast:
						{
							while(d < e)
							{
								unsigned char * rd = d;
								unsigned char * re = d + m_uRowstride;
								const unsigned char * sd = s;
								while(rd < re)
								{
									unsigned char a = *sd;
									if(a == 255)
									{
										*((UInt32 *)rd) = *((const UInt32 *)sd);
										rd += 4;
										sd += 4;
									} else if(a == 0)
									{
										*((UInt32 *)rd) = 0;
										rd += 4;
										sd += 4;
									} else {
										sd++;
										*rd++ = (*sd++ * 255) / a;
										*rd++ = (*sd++ * 255) / a;
										*rd++ = (*sd++ * 255) / a;
										*rd++ = a;
									}
								}
								d = re;
								s += uBytesPerRow;
							}
						}
						break;
*/
                        case kCGImageAlphaFirst:
						case kCGImageAlphaNoneSkipFirst:
							// FIXME: Should invert?
							if(uBytesPerRow == m_uRowstride)
							{
								memcpy(d,s,uBufferSize);
							} else {
								while(d < e)
								{
									memcpy(d,s,m_uRowstride);
									d += m_uRowstride;
									s += uBytesPerRow;
								}
							}
						break;
						case kCGImageAlphaNoneSkipLast:
						case kCGImageAlphaLast:
						case kCGImageAlphaNone:
							if(uBytesPerRow == m_uRowstride)
							{
								memcpy(d,s,uBufferSize);
							} else {
								while(d < e)
								{
									memcpy(d,s,m_uRowstride);
									d += m_uRowstride;
									s += uBytesPerRow;
								}
							}
						break;
						default:
							free(m_pBuffer);
							CFRelease(hData);
							SETSTS_NULL_IMAGE;
							return self;
						break;
					}
				break;
				default:
					free(m_pBuffer);
					CFRelease(hData);
					SETSTS_NULL_IMAGE;
					return self;
				break;
			}
		break;
		default:
			// aargh.. unsupported
			free(m_pBuffer);
			CFRelease(hData);
			SETSTS_NULL_IMAGE;
			return self;
		break;
	}
	
	CFRelease(hData);

	return self;
}

- (id)initWithWidth:(unsigned int)uWidth height:(unsigned int)uHeight channels:(unsigned int)uChannels
{
	self = [super init];
	if(!self)
		return nil;
	m_uWidth = uWidth;
	m_uHeight = uHeight;
	m_uChannels = uChannels;
	m_uRowstride = uWidth * uChannels;
	unsigned int uBufferSize = m_uHeight * m_uRowstride;
	if(uBufferSize > 0)
	{
		m_pBuffer = (unsigned char *)malloc(uBufferSize);
	} else {
		m_pBuffer = NULL;
		m_uWidth = 0;
		m_uHeight = 0;
		m_uChannels = 0;
		m_uRowstride = 0;
	}
	return self;
}

- (id)initWithWidth:(unsigned int)uWidth height:(unsigned int)uHeight channels:(unsigned int)uChannels rowstride:(unsigned int)uRowstride
{
	self = [super init];
	if(!self)
		return nil;
	m_uWidth = uWidth;
	m_uHeight = uHeight;
	m_uChannels = uChannels;
	unsigned int uMinRowstride = uWidth * uChannels;
	m_uRowstride = uRowstride >= uMinRowstride ? uRowstride : uMinRowstride;
	unsigned int uBufferSize = m_uHeight * m_uRowstride;
	if(uBufferSize > 0)
	{
		m_pBuffer = (unsigned char *)malloc(uBufferSize);
	} else {
		m_pBuffer = NULL;
		m_uWidth = 0;
		m_uHeight = 0;
		m_uChannels = 0;
		m_uRowstride = 0;
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

- (bool)isNull
{
	return m_pBuffer == NULL;
}

- (unsigned int)bufferSize
{
	return m_uWidth * m_uRowstride;
}

- (unsigned char *)buffer
{
	return m_pBuffer;
}

- (void)clear
{
	if(!m_pBuffer)
		return;
	free(m_pBuffer);
	m_pBuffer = NULL;
	m_uWidth = 0;
	m_uHeight = 0;
	m_uChannels = 0;
	m_uRowstride = 0;
}

/*-
+ (STSImage *)dropLastChannel
{
	if(!m_pBuffer)
		return nil;
		
	if(m_uChannels < 2)
		return [[STSImage alloc] init];
	
	STSImage * pDest = [[STSImage alloc] initWithWidth:m_uWidth height:m_uHeight channels:m_uChannels - 1];
	if(!pDest)
		return nil;
	
	unsigned char * d = [pDest buffer];
	
	
}
*/

+ (STSImage *)imageFromUIImage:(UIImage *)pImage
{
	return [[STSImage alloc] initWithUIImage:pImage];
}

- (UIImage *)createUIImage
{
	if(!m_pBuffer)
		return nil;

	CFDataRef hDataRef = CFDataCreate(NULL,m_pBuffer, m_uHeight * m_uRowstride); // copy data
	CGDataProviderRef hDataProvider = CGDataProviderCreateWithCFData(hDataRef);

	CGColorSpaceRef hColorSpace;
	CGBitmapInfo iBitmapInfo;
	
	switch(m_uChannels)
	{
		case 1:
			hColorSpace = CGColorSpaceCreateDeviceGray();
			iBitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaNone;
		break;
		case 4:
			hColorSpace = CGColorSpaceCreateDeviceRGB();
			iBitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaLast;
		break;
		default:
			hColorSpace = CGColorSpaceCreateDeviceRGB();
			iBitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaNone;
		break;
	}
	
	CGImageRef hImage = CGImageCreate(
			m_uWidth,
			m_uHeight,
			8,
			m_uChannels * 8,
			m_uRowstride,
			hColorSpace,
			iBitmapInfo,
			hDataProvider,
			NULL,
			YES,
			kCGRenderingIntentDefault
		);
	
	UIImage *result = [UIImage imageWithCGImage:hImage];
	
	CGDataProviderRelease(hDataProvider);
	CFRelease(hDataRef);

#if 0
	CGColorSpaceRef colorSpace;
	CGBitmapInfo info;

	switch(m_uChannels)
	{
		case 3:
			colorSpace = CGColorSpaceCreateDeviceRGB();
			info = kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Big;
		break;
		case 4:
			colorSpace = CGColorSpaceCreateDeviceRGB();
			info = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
		break;
		case 1:
		default:
			colorSpace = CGColorSpaceCreateDeviceGray();
			info = kCGImageAlphaNone | kCGBitmapByteOrder32Big;
		break;
	}

	CGContextRef context = CGBitmapContextCreate(
			m_pBuffer,
			m_uWidth,
			m_uHeight,
			8, // bits per component
			m_uRowstride,
			colorSpace,
			info
		);

	CGContextSetBlendMode(context, kCGBlendModeCopy);

	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	UIImage * result = [UIImage imageWithCGImage:imageRef];

	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
#endif
	return result;
}

@end
