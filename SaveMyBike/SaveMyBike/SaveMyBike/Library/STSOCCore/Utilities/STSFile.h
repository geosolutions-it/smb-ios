//
//  STSFile.h
//
//  Created by Szymon Tomasz Stefanek on 6/12/13.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSCore.h"

#import <UIKit/UIKit.h>

@interface STSFile : NSObject

+ (BOOL)fileExists:(NSString *)szPath;
+ (BOOL)removeFile:(NSString *)szPath;
+ (BOOL)copyFileFrom:(NSString *)szFrom to:(NSString *)szTo;

+ (bool)addSkipBackupAttributeToFileAtPath:(NSString *)szPath;

// Returns nil in case of success or an error description in case of error
+ (NSString *)writeData:(NSData *)pData toPath:(NSString *)szPath;
+ (NSData *)readDataFromPath:(NSString *)szPath;
+ (NSString *)readUTF8StringFromPath:(NSString *)szPath;

+ (BOOL)removeDirectory:(NSString *)szPath;
+ (BOOL)createDirectoryIfMissing:(NSString *)szPath;

@end
