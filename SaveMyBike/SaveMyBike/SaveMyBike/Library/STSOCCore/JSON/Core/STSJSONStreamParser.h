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

#import <Foundation/Foundation.h>

@class STSJSONTokeniser;
@class STSJSONStreamParser;
@class STSJSONStreamParserState;

typedef enum {
	STSJSONStreamParserComplete,
	STSJSONStreamParserWaitingForData,
	STSJSONStreamParserError,
} STSJSONStreamParserStatus;


/**
 @brief Delegate for interacting directly with the stream parser
 
 You will most likely find it much more convenient to implement the
 STSJSONStreamParserAdapterDelegate protocol instead.
 */
@protocol STSJSONStreamParserDelegate

/// Called when object start is found
- (void)parserFoundObjectStart:(STSJSONStreamParser*)parser;

/// Called when object key is found
- (void)parser:(STSJSONStreamParser*)parser foundObjectKey:(NSString*)key;

/// Called when object end is found
- (void)parserFoundObjectEnd:(STSJSONStreamParser*)parser;

/// Called when array start is found
- (void)parserFoundArrayStart:(STSJSONStreamParser*)parser;

/// Called when array end is found
- (void)parserFoundArrayEnd:(STSJSONStreamParser*)parser;

/// Called when a boolean value is found
- (void)parser:(STSJSONStreamParser*)parser foundBoolean:(BOOL)x;

/// Called when a null value is found
- (void)parserFoundNull:(STSJSONStreamParser*)parser;

/// Called when a number is found
- (void)parser:(STSJSONStreamParser*)parser foundNumber:(NSNumber*)num;

/// Called when a string is found
- (void)parser:(STSJSONStreamParser*)parser foundString:(NSString*)string;

@end


/**
 @brief Parse a stream of JSON data.
 
 Using this class directly you can reduce the apparent latency for each
 download/parse cycle of documents over a slow connection. You can start
 parsing *and return chunks of the parsed document* before the entire
 document is downloaded.
 
 Using this class is also useful to parse huge documents on disk
 bit by bit so you don't have to keep them all in memory. 
 
 @see STSJSONStreamParserAdapter for more information.
 
 
 */
@interface STSJSONStreamParser : NSObject {
@private
	STSJSONTokeniser *tokeniser;
}

@property (nonatomic, unsafe_unretained) STSJSONStreamParserState *state; // Private
@property (nonatomic, readonly, strong) NSMutableArray *stateStack; // Private

/**
 @brief Expect multiple documents separated by whitespace

 Normally the @p -parse: method returns STSJSONStreamParserComplete when it's found a complete JSON document.
 Attempting to parse any more data at that point is considered an error. ("Garbage after JSON".)
 
 If you set this property to true the parser will never return STSJSONStreamParserComplete. Rather,
 once an object is completed it will expect another object to immediately follow, separated
 only by (optional) whitespace.

 @see The TweetStream app in the Examples
 */
@property BOOL supportMultipleDocuments;

/**
 @brief Delegate to receive messages

 The object set here receives a series of messages as the parser breaks down the JSON stream
 into valid tokens.

 @note
 Usually this should be an instance of STSJSONStreamParserAdapter, but you can
 substitute your own implementation of the STSJSONStreamParserDelegate protocol if you need to. 
 */
@property (unsafe_unretained) id<STSJSONStreamParserDelegate> delegate;

/**
 @brief The max parse depth
 
 If the input is nested deeper than this the parser will halt parsing and return an error.

 Defaults to 32. 
 */
@property NSUInteger maxDepth;

/// Holds the error after STSJSONStreamParserError was returned
@property (copy) NSString *error;

/**
 @brief Parse some JSON
 
 The JSON is assumed to be UTF8 encoded. This can be a full JSON document, or a part of one.

 @param data An NSData object containing the next chunk of JSON

 @li STSJSONStreamParserComplete if a full document was found
 @li STSJSONStreamParserWaitingForData if a partial document was found and more data is required to complete it
 @li STSJSONStreamParserError if an error occured. (See the error property for details in this case.)
 
 */
- (STSJSONStreamParserStatus)parse:(NSData*)data;

@end
