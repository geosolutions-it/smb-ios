//
//  STSURLRequest.m
//
//  Created by Szymon Tomasz Stefanek on 10/31/12.
//  Copyright (c) 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSURLRequest.h"
#import "NSString+URL.h"

@interface STSURLRequest()
{
	@private
		NSURLConnection * m_pConnection;
		NSURL * m_oTargetURL;
		NSMutableDictionary<NSString *,NSString*> * m_pHeaders;
		double m_dConnectionTimeout;
		STSURLRequestOutputMode m_eOutputMode;
		NSString * m_szOutputFileName;
		NSFileHandle * m_pOutputFileHandle;
		NSURLRequestCachePolicy m_eCachePolicy;
		NSString * m_szHttpMethod;
		NSData * m_pHttpBody;
		NSMutableData * m_pDataBuffer;
		NSString * m_szFailureReason;
		NSMutableURLRequest * m_pRequest;
		STSURLRequestResult m_eResult;
		int m_iStatusCode;
		bool m_bCaptureOutputInCaseOfError;
		__weak id<STSURLRequestCompletionHandlerDelegate> m_pCompletionHandler;
		__weak id<STSURLRequestDataHandlerDelegate> m_pDataHandler;
}

// PRIVATE STUFF

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

- (void)_failWithError:(NSString *)szError;

@end

@implementation STSURLRequest

- (id)init
{
	self = [super init];
	if(!self)
		return nil;

	m_pConnection = nil;
	m_oTargetURL = nil;
	m_pHeaders = nil;
	m_dConnectionTimeout = 30.0;
	m_eOutputMode = STSURLRequestOutputToDelegate;
	m_szOutputFileName = nil;
	m_szHttpMethod = @"GET";
	m_pHttpBody = nil;
	// Caching thrashes memory a lot (memory doesn't seem to be freed at all)
	m_eCachePolicy = NSURLRequestReloadIgnoringCacheData;
	m_pOutputFileHandle = nil;
	m_eResult = STSURLRequestPending;
	m_szFailureReason = [NSString string];
	m_pCompletionHandler = nil;
	m_bCaptureOutputInCaseOfError = false;
	m_iStatusCode = 0;
	m_pRequest = nil;
	m_pDataHandler = nil;
	m_pDataBuffer = nil;

	return self;
}

- (void)dealloc
{
	m_pCompletionHandler = nil;
	m_pDataHandler = nil;
	
	if(m_pConnection)
	{
		[m_pConnection cancel];
		m_pConnection = nil;
	}

	if(m_pDataBuffer)
	{
		// how to free this shit?
		m_pDataBuffer = nil;
	}

	if(m_pOutputFileHandle)
	{
		[m_pOutputFileHandle closeFile];
		m_pOutputFileHandle = nil;
	}

	m_pRequest = nil;
}

- (STSURLRequestResult)result
{
	return m_eResult;
}

- (int)statusCode
{
	return m_iStatusCode;
}

- (void)setCaptureOutputInCaseOfError:(bool)bCapture
{
	m_bCaptureOutputInCaseOfError = bCapture;
}

- (NSURL *)targetURL
{
	return m_oTargetURL;
}

- (void)setTargetURL:(NSURL *)oURL
{
	m_oTargetURL = oURL;
}

- (void)setTargetURLWithString:(NSString *)szURL
{
	assert(szURL);
	m_oTargetURL = [szURL toURL];
}

- (double)connectionTimeout
{
	return m_dConnectionTimeout;
}

- (void)setConnectionTimeout:(double)dTimeout
{
	m_dConnectionTimeout = dTimeout;
}

- (STSURLRequestOutputMode)outputMode
{
	return m_eOutputMode;
}

- (void)setOutputMode:(STSURLRequestOutputMode)eMode
{
	m_eOutputMode = eMode;
}

- (void)setCompletionHandlerDelegate:(__weak id<STSURLRequestCompletionHandlerDelegate>)pDelegate
{
	m_pCompletionHandler = pDelegate;
}

- (void)setDataHandlerDelegate:(__weak id<STSURLRequestDataHandlerDelegate>)pDelegate
{
	m_pDataHandler = pDelegate;
}

- (void)setOutputFileName:(NSString *)szFileName
{
	m_szOutputFileName = szFileName;
}

- (void)setHttpBody:(NSData *)pData
{
	m_pHttpBody = pData;
}

- (void)setHttpMethod:(NSString *)szString
{
	m_szHttpMethod = szString;
}

- (void)setHeaders:(NSMutableDictionary<NSString *,NSString *> *)pHeaders
{
	m_pHeaders = pHeaders;
}

- (void)addHeader:(NSString *)szHeader withValue:(NSString *)szValue
{
	if(!m_pHeaders)
		m_pHeaders = [NSMutableDictionary new];
	[m_pHeaders setValue:szValue forKey:szHeader];
}

- (bool)start
{
	if(m_pConnection)
	{
		m_eResult = STSURLRequestFailed;
		m_szFailureReason = @"Connection already running: connection objects can't be reused";
		return false;
	}
	
	if(!m_oTargetURL)
	{
		m_eResult = STSURLRequestFailed;
		m_szFailureReason = @"No target URL specified";
		return false;
	}
	
	NSString * scheme = [m_oTargetURL scheme];
	if(!scheme)
	{
		m_eResult = STSURLRequestFailed;
		m_szFailureReason = @"Bad url scheme";
		return false;
	}

	if(![scheme hasPrefix:@"http"])
	{
		m_eResult = STSURLRequestFailed;
		m_szFailureReason = @"Unsupported url scheme";
		return false;
	}

	switch(m_eOutputMode)
	{
		case STSURLRequestOutputIgnore:
		break;
		case STSURLRequestOutputToDelegate:
		case STSURLRequestOutputToDelegateInChunks:
			m_pDataBuffer = [[NSMutableData alloc] initWithCapacity:1024];
		break;
		case STSURLRequestOutputToFile:
			if(!m_szOutputFileName)
			{
				m_eResult = STSURLRequestFailed;
				m_szFailureReason = @"Output to file specified but no filename provided";
				return false;
			}
			
			m_pOutputFileHandle = [NSFileHandle fileHandleForWritingAtPath:m_szOutputFileName];
			if(!m_pOutputFileHandle)
			{
				[[NSFileManager defaultManager] createFileAtPath:m_szOutputFileName contents:nil attributes:nil];
				m_pOutputFileHandle = [NSFileHandle fileHandleForWritingAtPath:m_szOutputFileName];
				if(!m_pOutputFileHandle)
				{
					m_eResult = STSURLRequestFailed;
					m_szFailureReason = @"Can't open the output file";
					return false;
				}
			}

		break;
		default:
			m_eResult = STSURLRequestFailed;
			m_szFailureReason = @"Bad output mode";
			return false;			
		break;
	}
	

	m_pRequest = [NSMutableURLRequest requestWithURL:m_oTargetURL
										 cachePolicy:NSURLRequestUseProtocolCachePolicy
									 timeoutInterval:m_dConnectionTimeout];

	if(m_szHttpMethod)
		[m_pRequest setHTTPMethod:m_szHttpMethod];

	if(m_pHttpBody)
		[m_pRequest setHTTPBody:m_pHttpBody];

	[m_pRequest setCachePolicy:m_eCachePolicy];
	[m_pRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];

	if(m_pHeaders)
	{
		for(NSString * key in m_pHeaders)
		{
			NSString * val = [m_pHeaders objectForKey:key];
			[m_pRequest setValue:val forHTTPHeaderField:key];
		}
	}

	//[m_pRequest setValue:@"Close" forHTTPHeaderField:@"Connection"];
	
	//NSLog(@"Connecting to %@",m_oTargetURL.absoluteString);

	m_pConnection = [NSURLConnection connectionWithRequest:m_pRequest delegate:self];
	
	return true;
}

- (void)cancel:(bool)bTriggerCompletionEvents
{
	if(m_pConnection)
	{
		[m_pConnection cancel];
		m_pConnection = nil;
	}

	if(m_pOutputFileHandle)
	{
		[m_pOutputFileHandle closeFile];
		m_pOutputFileHandle = nil;
	}	

	m_eResult = STSURLRequestCanceled;
	
	if(bTriggerCompletionEvents && m_pCompletionHandler)
		[m_pCompletionHandler requestDidComplete:self];
	
	
	if(m_pDataBuffer)
	{
		// how to free this shit?
		m_pDataBuffer = nil;
	}
	
	m_pCompletionHandler = nil;
	m_pDataHandler = nil;
}

- (void)_failWithError:(NSString *)szError
{
	if(m_pConnection)
	{
		[m_pConnection cancel];
		m_pConnection = nil;
	}
	
	if(m_pOutputFileHandle)
	{
		[m_pOutputFileHandle closeFile];
		m_pOutputFileHandle = nil;
	}
	
	m_eResult = STSURLRequestFailed;
	m_szFailureReason = szError;

	if(m_pCompletionHandler)
		[m_pCompletionHandler requestDidComplete:self];
	
	
	if(m_pDataBuffer)
	{
		// how to free this shit?
		m_pDataBuffer = nil;
	}
	
	m_pCompletionHandler = nil;
	m_pDataHandler = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	assert(connection == m_pConnection);

	switch(m_eOutputMode)
	{
		case STSURLRequestOutputIgnore:
		break;
		case STSURLRequestOutputToDelegate:
			if(!m_pDataBuffer)
			{
				[self _failWithError:@"Internal error: data buffer not initialized"];
				return;
			}
			
			[m_pDataBuffer appendData:data];
		break;
		case STSURLRequestOutputToDelegateInChunks:
			if(m_pDataHandler)
				[m_pDataHandler request:self didReceiveData:data];
		break;
		case STSURLRequestOutputToFile:
			if(!m_pOutputFileHandle)
			{
				[self _failWithError:@"Internal error: output file not open"];
				return;
			}

			@try
			{
				[m_pOutputFileHandle writeData:data];				
			}
			@catch (NSException * e)
			{
				[self _failWithError:[NSString stringWithFormat:@"Failed to write to the output file: %@", e.reason]];
			}
			
		break;
		default:			
			return;			
		break;
	}

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	assert(connection == m_pConnection);
	
	if([response respondsToSelector:@selector(statusCode)])
	{
		NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;	
		//STS_CORE_LOG(@"Status code is %d",[httpResponse statusCode]);
		//NSDictionary *dictionary = [httpResponse allHeaderFields];
		//STS_CORE_LOG(@"%@",[dictionary description]);
		m_iStatusCode = (int)[httpResponse statusCode];

		if((!m_bCaptureOutputInCaseOfError) && (m_iStatusCode >= 400))
		{
			// some kind of error
			[self _failWithError:[NSString stringWithFormat:@"Server returned error %d: %@",m_iStatusCode,[NSHTTPURLResponse localizedStringForStatusCode:m_iStatusCode]]];
			return;
		}
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	assert(connection == m_pConnection);
	
	//NSLog(@"GOTERROR:%@",error.description);
	//NSLog(@"GOTERROR:%@",error.domain);
	//NSLog(@"GOTERROR:%@",error.localizedDescription);
	//NSLog(@"GOTERROR:%@",error.localizedFailureReason);
	//NSLog(@"GOTERROR:%@",error.localizedRecoveryOptions);
	
	[self _failWithError:error.localizedDescription];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    if(response && m_pRequest)
	{
		// clone my own request (so POST data is preserved
		m_pRequest = [m_pRequest mutableCopy]; // original request
        [m_pRequest setURL: [request URL]];
        return m_pRequest;
    }
	
	return request;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	assert(connection == m_pConnection);
	
	m_pConnection = nil;

	if(m_pOutputFileHandle)
	{
		[m_pOutputFileHandle closeFile];
		m_pOutputFileHandle = nil;
	}

	m_eResult = STSURLRequestSucceeded;

	switch(m_eOutputMode)
	{
		case STSURLRequestOutputToDelegate:
			if(m_pDataBuffer && m_pDataHandler)
				[m_pDataHandler request:self didReceiveData:m_pDataBuffer];
		break;
		default:
			// nuthin
		break;
	}

	if(m_iStatusCode >= 400)
	{
		// some kind of error
		[self _failWithError:[NSString stringWithFormat:@"Server returned error %d: %@",m_iStatusCode,[NSHTTPURLResponse localizedStringForStatusCode:m_iStatusCode]]];
		return;
	}

	if(m_pCompletionHandler)
		[m_pCompletionHandler requestDidComplete:self];

	if(m_pDataBuffer)
	{
		// how to free this shit?
		m_pDataBuffer = nil;
	}
	
	m_pCompletionHandler = nil;
	m_pDataHandler = nil;
}

- (NSString *)failureReason
{
	return m_szFailureReason;
}

@end

