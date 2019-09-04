/*
 Copyright (c) 2010, Stig Brautaset.
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:

	 Redistributions of source code must retain the above copyright
	 notice, this list of conditions and the following disclaimer.

	 Redistributions in binary form must reproduce the above copyright
	 notice, this list of conditions and the following disclaimer in the
	 documentation and/or other materials provided with the distribution.

	 Neither the name of the the author nor the names of its contributors
	 may be used to endorse or promote products derived from this software
	 without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRSTSTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "STSJSONStreamWriterState.h"
#import "STSJSONStreamWriter.h"

#define SINGLETON \
+ (id)sharedInstance { \
		static id state; \
		if (!state) state = [[self alloc] init]; \
		return state; \
}


@implementation STSJSONStreamWriterState
+ (id)sharedInstance { return nil; }
- (BOOL)isInvalidState:(STSJSONStreamWriter*)writer { return NO; }
- (void)appendSeparator:(STSJSONStreamWriter*)writer {}
- (BOOL)expectingKey:(STSJSONStreamWriter*)writer { return NO; }
- (void)transitionState:(STSJSONStreamWriter *)writer {}
- (void)appendWhitespace:(STSJSONStreamWriter*)writer {
	[writer appendBytes:"\n" length:1];
	for (NSUInteger i = 0; i < writer.stateStack.count; i++)
	    [writer appendBytes:"	" length:1];
}
@end

@implementation STSJSONStreamWriterStateObjectStart

SINGLETON

- (void)transitionState:(STSJSONStreamWriter *)writer {
	writer.state = [STSJSONStreamWriterStateObjectValue sharedInstance];
}
- (BOOL)expectingKey:(STSJSONStreamWriter *)writer {
	writer.error = @"JSON object key must be string";
	return YES;
}
@end

@implementation STSJSONStreamWriterStateObjectKey

SINGLETON

- (void)appendSeparator:(STSJSONStreamWriter *)writer {
	[writer appendBytes:"," length:1];
}
@end

@implementation STSJSONStreamWriterStateObjectValue

SINGLETON

- (void)appendSeparator:(STSJSONStreamWriter *)writer {
	[writer appendBytes:":" length:1];
}
- (void)transitionState:(STSJSONStreamWriter *)writer {
		writer.state = [STSJSONStreamWriterStateObjectKey sharedInstance];
}
- (void)appendWhitespace:(STSJSONStreamWriter *)writer {
	[writer appendBytes:" " length:1];
}
@end

@implementation STSJSONStreamWriterStateArrayStart

SINGLETON

- (void)transitionState:(STSJSONStreamWriter *)writer {
		writer.state = [STSJSONStreamWriterStateArrayValue sharedInstance];
}
@end

@implementation STSJSONStreamWriterStateArrayValue

SINGLETON

- (void)appendSeparator:(STSJSONStreamWriter *)writer {
	[writer appendBytes:"," length:1];
}
@end

@implementation STSJSONStreamWriterStateStart

SINGLETON


- (void)transitionState:(STSJSONStreamWriter *)writer {
		writer.state = [STSJSONStreamWriterStateComplete sharedInstance];
}
- (void)appendSeparator:(STSJSONStreamWriter *)writer {
}
@end

@implementation STSJSONStreamWriterStateComplete

SINGLETON

- (BOOL)isInvalidState:(STSJSONStreamWriter*)writer {
	writer.error = @"Stream is closed";
	return YES;
}
@end

@implementation STSJSONStreamWriterStateError

SINGLETON

@end

