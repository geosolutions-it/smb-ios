//
//  POParser.m
//  pomo
//
//  Created by pronebird on 3/28/11.
//  Copyright 2011 Andrej Mihajlov. All rights reserved.
//

#import "POParser.h"

@implementation POParser

- (BOOL)importFileAtPath:(NSString*)filename
{
	TranslationEntry* entry = nil;
	NSArray* split = nil;
	NSError* err = nil;
	NSString* fileContents = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:&err];

	split = [fileContents componentsSeparatedByString:@"\n\n"];

	for(NSString* str in split)
	{
		if((entry = [self readEntry:str]) != nil)
		{
			//[entry debugPrint];
			[self addEntry:entry];
		}
	}

	return YES;
}

typedef enum _CurrentSection
{
	CurrentSectionNone,
	CurrentSectionMsgid,
	CurrentSectionMsgstr,
	CurrentSectionMsgctxt,
	CurrentSectionMsgid_plural
} CurrentSection;


- (void)setTranslationEntry:(TranslationEntry *)te section:(CurrentSection)eCurrentSection toValue:(NSString *)szVal
{
	switch(eCurrentSection)
	{
		case CurrentSectionNone:
			// BUG
		break;
		case CurrentSectionMsgstr:
			[te.translations addObject:szVal];
		break;
		case CurrentSectionMsgctxt:
			te.context = szVal;
		break;
		case CurrentSectionMsgid:
			te.singular = szVal;
		break;
		case CurrentSectionMsgid_plural:
			te.plural = szVal;
			te.is_plural = true;
		break;
	}
}

- (TranslationEntry*)readEntry:(NSString*)entryString
{
	NSArray* strings = [entryString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	TranslationEntry * entry = [TranslationEntry new];
	
	CurrentSection eCurrentSection = CurrentSectionNone;
	
	NSMutableString * buffer = [NSMutableString stringWithCapacity:100];
	
	for(NSString* s in strings)
	{
		NSString* str = s;
		
		if(!str.length)
			continue;

		if([str characterAtIndex:0] == '"' && [str characterAtIndex:str.length-1] == '"')
		{
			if(eCurrentSection == CurrentSectionNone)
			{
				// bug or broken file
				continue;
			}
		
			// "...."
			// This is a continuation string
			[buffer appendString:[self decodeValueAndRemoveQuotes:str]];
			continue;
		}

		NSArray * arr = [self splitString:str separator:@" "];
		NSString * key, *value;

		NSUInteger keylen = 0;
		
		if(arr.count < 2)
			continue;
			
		key = [arr objectAtIndex:0];
		value = [arr objectAtIndex:1];
			
		keylen = key.length;

		if([str characterAtIndex:0] == '#') // #. section
		{
			// don't use "key" here because of #_ (space) format
			// for translator comments
			unichar c = [str characterAtIndex:1];
				
			switch(c)
			{
				// reference
				case ':':
					[entry.references addObject:value];
				break;
					
				// flag
				case ',':
					[entry.flags addObject:value];
				break;
						
				// translator comments
				case ' ':
					entry.translator_comments = value;
				break;
					
				// extracted comments
				case '.':
					entry.extracted_comments = value;
				break;
					
				// previous message, not implemented
				case '|':
					break;
					
				default:
					continue;
					break;
			}
			
			continue;
		}

		if(eCurrentSection != CurrentSectionNone)
			[self setTranslationEntry:entry section:eCurrentSection toValue:buffer];
		buffer = [NSMutableString stringWithCapacity:100];
		
		[buffer appendString:[self decodeValueAndRemoveQuotes:value]];
		
		if([key isEqualToString:@"msgctxt"]) // msgctxt
			eCurrentSection = CurrentSectionMsgctxt;
		else if([key isEqualToString:@"msgid"]) // msgid
			eCurrentSection = CurrentSectionMsgid;
		else if([key isEqualToString:@"msgstr"]) // msgid
			eCurrentSection = CurrentSectionMsgstr;
		else if([key isEqualToString:@"msgid_plural"]) // msgid
			eCurrentSection = CurrentSectionMsgid_plural;
		else if(keylen >= 8 && [[key substringWithRange:NSMakeRange(0, 7)] isEqualToString:@"msgstr["])
			eCurrentSection = CurrentSectionMsgstr;
		else
			eCurrentSection = CurrentSectionNone;
	}

	if(eCurrentSection != CurrentSectionNone)
		[self setTranslationEntry:entry section:eCurrentSection toValue:buffer];

	if((!entry.is_plural) && ((!entry.singular) || (entry.singular.length < 1)))
	{
		// HEADER!
		if(entry.translations.count > 0)
		{
			NSString * tr = [entry.translations objectAtIndex:0];
			NSArray * arx = [tr componentsSeparatedByString:@"\n"];
			for(NSString * ary in arx)
			{
				NSArray * arz = [ary componentsSeparatedByString:@":"];
				if(arz.count < 2)
					continue;

				NSString* value = [[self decodePOString:[arz objectAtIndex:1]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

				[self setHeader:[arz objectAtIndex:0] value:value];
			}
		}
		
		return nil;
	}

	return entry;
}

- (NSString*)decodeValueAndRemoveQuotes:(NSString*)string {
	NSUInteger x = 0, y = 0;
	
	string = [self decodePOString:string];
	
	y = string.length;
	
	if(y) {
		if([string characterAtIndex:0] == '"')
		{
			x++;
		}
		
		if(x < y && [string characterAtIndex:string.length-1] == '"')
		{
			y--;
		}
		
		string = [string substringWithRange:NSMakeRange(x, y-x)];
	}
	
	return string;
}

- (NSString*)decodePOString:(NSString*)string {
	string = [string stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
	string = [string stringByReplacingOccurrencesOfString:@"\\t" withString:@"\t"];
	string = [string stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
	string = [string stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];

	return string;
}

- (NSString*)encodePOString:(NSString*)string {
	string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
	string = [string stringByReplacingOccurrencesOfString:@"\\t" withString:@"\t"];
	string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
	string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];

	return string;
}

- (NSArray*)splitString:(NSString*)string separator:(NSString*)separator
{
	NSScanner* scan = [NSScanner scannerWithString:string];
	NSString* token = nil;
	NSMutableArray* array = [NSMutableArray new];
	
	if([scan scanUpToString:separator intoString:&token])
	{
		[array addObject:token];
		
		NSUInteger pos = [scan scanLocation]+1;
		
		if(pos < string.length) {
			[array addObject:[string substringFromIndex:pos]];
		}
	}
	
	return [NSArray arrayWithArray:array];	
}

@end




