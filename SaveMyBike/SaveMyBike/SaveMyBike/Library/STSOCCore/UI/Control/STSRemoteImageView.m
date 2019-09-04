//
//  STSRemoteImageView.m
//
//  Created by Szymon Tomasz Stefanek on 2/23/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSRemoteImageView.h"

#import "STSCachedImageDownloader.h"
#import "STSCore.h"

@interface STSRemoteImageView()<STSCachedImageDownloaderDelegate>
{
	NSString * m_szURL;
	NSString * m_szPlaceholderImageName;
	BOOL m_bRequestPending;
	BOOL m_bForceSquareAppearance;
}
@end

@implementation STSRemoteImageView

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	[self _initRemoteImageView];
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(!self)
		return nil;
	[self _initRemoteImageView];
	return self;
}

- (id)initWithDownloader:(STSCachedImageDownloader *)pDownloader andDownloaderCategory:(NSString *)szDownloaderCategory;
{
	self = [super init];
	if(!self)
		return nil;
	[self _initRemoteImageView];
	self.cachedImageDownloader = pDownloader;
	self.cachedImageDownloaderCategory = szDownloaderCategory;
	return self;
}

- (void)_initRemoteImageView
{
	self.contentMode = UIViewContentModeScaleAspectFill;
	self.clipsToBounds = YES;
	m_bForceSquareAppearance = false;
}

- (void)dealloc
{
	if(m_bRequestPending)
		[self.cachedImageDownloader abortImageRequestForCategory:self.cachedImageDownloaderCategory URL:m_szURL andDelegate:self];
}

- (void)setForceSquareAppearance:(BOOL)bForceIt
{
	if(m_bForceSquareAppearance == bForceIt)
		return;
	m_bForceSquareAppearance = bForceIt;
	[self setNeedsLayout];
}

- (CGSize)intrinsicContentSize
{
	CGSize s = [super intrinsicContentSize];
	
	if(!m_bForceSquareAppearance)
		return s;
	
	return CGSizeMake(s.width,s.width);
}

- (CGSize)sizeThatFits:(CGSize)size
{
	if(m_bForceSquareAppearance)
		return CGSizeMake(size.width,size.width);
	
	return [super sizeThatFits:size];
}

- (void)setImageFile:(NSString *)szImagePath
{
	[self setImageURL:nil andPlaceholder:nil];
	
	if((!szImagePath) || (szImagePath.length < 1))
		return;
	
	if([szImagePath containsString:@"/"])
		self.image = [UIImage imageWithContentsOfFile:szImagePath];
	else
		self.image = [UIImage imageNamed:szImagePath];
}

- (void)setImageURL:(NSString *)szURL andPlaceholder:(NSString *)szPlaceholderImageName
{
	if(szURL == nil)
	{
		if(m_bRequestPending)
		{
			[self.cachedImageDownloader abortImageRequestForCategory:self.cachedImageDownloaderCategory URL:m_szURL andDelegate:self];
			m_bRequestPending = FALSE;
		}

		if(szPlaceholderImageName == nil)
		{
			self.image = nil;
			m_szPlaceholderImageName = szPlaceholderImageName;
			m_szURL = szURL;
			return;
		}
		
		if(m_szPlaceholderImageName && (!m_szURL) && [m_szPlaceholderImageName isEqualToString:szPlaceholderImageName])
			return; // same as current

		UIImage * img = [UIImage imageNamed:szPlaceholderImageName];
		self.image = img;
		m_szPlaceholderImageName = szPlaceholderImageName;
		m_szURL = szURL;
		return;
	}

	if(
		m_szURL &&
		[m_szURL isEqualToString:szURL] &&
		(
			(
		 		!m_szPlaceholderImageName &&
			 	!szPlaceholderImageName
			) ||
		 	(
		 		m_szPlaceholderImageName &&
			 	szPlaceholderImageName &&
			 	[m_szPlaceholderImageName isEqualToString:szPlaceholderImageName]
		 	)
		)
	)
		return; // same

	if(m_bRequestPending)
	{
		[self.cachedImageDownloader abortImageRequestForCategory:self.cachedImageDownloaderCategory URL:m_szURL andDelegate:self];
		m_bRequestPending = FALSE;
	}
	
	UIImage * pImage = [self.cachedImageDownloader cachedImageForCategory:self.cachedImageDownloaderCategory andURL:szURL];
	if(pImage)
	{
		self.image = pImage;
		m_szPlaceholderImageName = szPlaceholderImageName;
		m_szURL = szURL;
		return;
	}
	
	if(szPlaceholderImageName)
	{
		UIImage * img = [UIImage imageNamed:szPlaceholderImageName];
		self.image = img;
	}
	
	[self.cachedImageDownloader requestImageForCategory:self.cachedImageDownloaderCategory URL:szURL andDelegate:self];

	m_bRequestPending = TRUE;
	m_szPlaceholderImageName = szPlaceholderImageName;
	m_szURL = szURL;
}

- (void)cachedImageDownloader:(STSCachedImageDownloader *)pDownloader receivedImage:(UIImage *)pImage forCategory:(NSString *)szCategory andURL:(NSString *)szURL
{
	m_bRequestPending = FALSE;
	self.image = pImage;
}

- (void)cachedImageDownloader:(STSCachedImageDownloader *)pDownloader failedToReceiveImageForCategory:(NSString *)szCategory URL:(NSString *)szURL withError:(NSString *)szError
{
	STS_CORE_LOG_ERROR(@"Failed to download image for url %@ and category %@: %@",szURL,szCategory,szError);
	m_bRequestPending = FALSE;
}

@end
