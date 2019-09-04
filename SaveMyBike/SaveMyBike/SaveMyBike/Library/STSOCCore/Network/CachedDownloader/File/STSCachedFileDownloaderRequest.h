//
//  STSCachedFileDownloaderRequest.h 
//
//  Created by Szymon Tomasz Stefanek on 3/5/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STSStaticContentDownload;
@class STSDelegateArray;

@interface STSCachedFileDownloaderRequest : NSObject

@property (nonatomic,strong) NSString * category;
@property (nonatomic,strong) NSString * URL;
@property (nonatomic,strong) NSString * fullFilePath;
@property (nonatomic,strong) NSString * temporaryFilePath;
@property (nonatomic,strong) STSStaticContentDownload * download;
@property (nonatomic,strong) STSDelegateArray * fileDelegateArray;

@end
