//
//  STSURLDownload.m
//
//  Created by Szymon Tomasz Stefanek on 9/1/18.
//  Copyright © 2018 Szymon Tomasz Stefanek
//

#import "STSURLDownload.h"

#import "STSURLRequest.h"
#import "NSString+URL.h"

#import "STSCore.h"

@interface STSURLDownload()
{
	NSMutableDictionary<NSString *,NSString *> * m_pHeaders;
}

@end

@implementation STSURLDownload

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	self.statusCode = 0;
	self.captureOutputInCaseOfError = false;
	return self;
}

- (void)addHeader:(NSString *)szHeader withValue:(NSString *)szValue
{
	if(!m_pHeaders)
		m_pHeaders = [NSMutableDictionary new];
	[m_pHeaders setObject:szValue forKey:szHeader];
}

- (STSURLRequest *)_createRequest
{
	STSURLRequest * r = [[STSURLRequest alloc] init];
	
	[r setTargetURL:[_URL toURL]];
	
	STS_CORE_LOG(@"Creating request for URL %@",_URL);

	if(_method)
		[r setHttpMethod:_method];
	if(_body)
		[r setHttpBody:_body];
	if(m_pHeaders)
		[r setHeaders:m_pHeaders];
	
	if(_captureOutputInCaseOfError)
		[r setCaptureOutputInCaseOfError:true];

	return r;
}

@end
