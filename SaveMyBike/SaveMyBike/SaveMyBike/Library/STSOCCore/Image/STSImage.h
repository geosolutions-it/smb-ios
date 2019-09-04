//
// STSImage.h
//
// Created by Szymon Tomasz Stefanek on 22/03/2013
// Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface STSImage : NSObject
{
@private
	///
	/// Width in pixels
	///
	unsigned int m_uWidth;

	///
	/// Height in pixels
	///
	unsigned int m_uHeight;

	///
	/// The number of channels.
	///
	unsigned int m_uChannels;
	
	///
	/// The rowstride (number of channels per row)
	///
	unsigned int m_uRowstride;

	///
	/// The memory buffer. May be null.
	///
	unsigned char * m_pBuffer;
}


- (id)init;
- (id)initWithWidth:(unsigned int)uWidth height:(unsigned int)uHeight channels:(unsigned int)uChannels;
- (id)initWithWidth:(unsigned int)uWidth height:(unsigned int)uHeight channels:(unsigned int)uChannels rowstride:(unsigned int)uRowstride;
- (id)initWithUIImage:(UIImage *)pImage;

- (void)dealloc;

- (void)clear; // sets the image null

+ (STSImage *)imageFromUIImage:(UIImage *)pImage;
- (UIImage *)createUIImage;

/*
+ (STSImage *)dropLastChannel;
*/

@property (readonly, nonatomic) bool isNull;
@property (readonly, nonatomic) unsigned int width;
@property (readonly, nonatomic) unsigned int height;
@property (readonly, nonatomic) unsigned int channels;
@property (readonly, nonatomic) unsigned int rowstride;
@property (readonly, nonatomic) unsigned int bufferSize;
@property (readonly, nonatomic) unsigned char * buffer;

@end