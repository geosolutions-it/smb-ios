//
//  STSFile.m
//
//  Created by Szymon Tomasz Stefanek on 6/12/13.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSFile.h"

#include <sys/xattr.h> // Needed import for setting file attributes


@implementation STSFile

+ (BOOL)fileExists:(NSString *)szPath
{
	if(!szPath)
		return FALSE;

	NSFileManager * fm = [NSFileManager defaultManager];
	if(!fm)
		return false;

	BOOL bIsDir = FALSE;
	
	if([fm fileExistsAtPath:szPath isDirectory:&bIsDir])
		return !bIsDir;
	
	return false;
}

+ (BOOL)removeFile:(NSString *)szPath
{
	if(!szPath)
		return FALSE;

	NSFileManager * fm = [NSFileManager defaultManager];
	if(!fm)
		return false;
	
	return [fm removeItemAtPath:szPath error:nil];
}

+ (BOOL)removeDirectory:(NSString *)szPath
{
	if(!szPath)
		return FALSE;
	
	NSFileManager * fm = [NSFileManager defaultManager];
	if(!fm)
		return false;
	
	return [fm removeItemAtPath:szPath error:nil];
}


+ (BOOL)copyFileFrom:(NSString *)szFrom to:(NSString *)szTo
{
	if(!szFrom)
		return FALSE;
	if(!szTo)
		return false;
	
	NSFileManager * fm = [NSFileManager defaultManager];
	if(!fm)
		return false;
	
	BOOL bIsDir = FALSE;
	
	if(![fm fileExistsAtPath:szFrom isDirectory:&bIsDir])
		return false;
	if(bIsDir)
		return false;

	return [fm copyItemAtPath:szFrom toPath:szTo error:nil];
}

+ (BOOL)createDirectoryIfMissing:(NSString *)szPath;
{
	if(!szPath)
		return false;

	NSFileManager * fm = [NSFileManager defaultManager];
	if(!fm)
		return false;
	
	BOOL bIsDir = FALSE;
	
	if([fm fileExistsAtPath:szPath isDirectory:&bIsDir])
		return bIsDir;
	
	return [fm createDirectoryAtPath:szPath withIntermediateDirectories:true attributes:nil error:nil];
}

+ (bool)addSkipBackupAttributeToFileAtPath:(NSString *)szPath
{
	// First ensure the file actually exists
	if(![[NSFileManager defaultManager] fileExistsAtPath:szPath])
		return false;

    // Determine the iOS version to choose correct skipBackup method
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];

	if([currSysVer isEqualToString:@"5.0.1"])
	{
		const char* filePath = [szPath fileSystemRepresentation];
		const char* attrName = "com.apple.MobileBackup";
		u_int8_t attrValue = 1;
		int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
		//STS_CORE_LOG(@"Excluded '%@' from backup",szPath);
		return result == 0;

	}
	
	if(NSURLIsExcludedFromBackupKey)
	{
		NSError *error = nil;
		NSURL * szURL = [NSURL fileURLWithPath:szPath];
		BOOL result = [szURL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
        if(result == NO)
		{
			STS_CORE_LOG_ERROR(@"Error excluding '%@' from backup. Error: %@",szPath,[error localizedDescription]);
			return false;
		}
		//STS_CORE_LOG(@"Excluded '%@' from backup",szPath);
		return true;
	}

	// iOS version is below 5.0, no need to do anything
	return true;
}

+ (NSString *)writeData:(NSData *)pData toPath:(NSString *)szPath
{
	if(!pData)
		return @"Null data passed";
	NSError * error = nil;
	if([pData writeToFile:szPath options:NSDataWritingAtomic error:&error])
		return nil;
	if(!error)
		return @"I/O call failed";
	return [error localizedDescription];
}

+ (NSData *)readDataFromPath:(NSString *)szPath
{
	if(!szPath)
		return nil;
	return [NSData dataWithContentsOfFile:szPath];
}

+ (NSString *)readUTF8StringFromPath:(NSString *)szPath
{
	if(!szPath)
		return nil;
	NSData * data = [NSData dataWithContentsOfFile:szPath];
	if(!data)
		return nil;
	return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


@end
