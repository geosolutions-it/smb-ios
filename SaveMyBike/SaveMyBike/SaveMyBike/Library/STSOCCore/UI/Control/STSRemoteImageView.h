//
//  STSRemoteImageView.h
//  
//  Created by Szymon Tomasz Stefanek on 2/23/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STSCachedImageDownloader;

@interface STSRemoteImageView : UIImageView

@property(nonatomic) NSObject * payload;
@property(nonatomic) STSCachedImageDownloader * cachedImageDownloader;
@property(nonatomic) NSString * cachedImageDownloaderCategory;

// when using these two you MUST set the downloader and the category
- (id)init;
- (id)initWithFrame:(CGRect)frame;

- (id)initWithDownloader:(STSCachedImageDownloader *)pDownloader andDownloaderCategory:(NSString *)szDownloaderCategory;
- (void)setImageURL:(NSString *)szURL andPlaceholder:(NSString *)szPlaceholderImageName;
- (void)setImageFile:(NSString *)szImagePath;

- (void)setForceSquareAppearance:(BOOL)bForceIt;

@end
