//
//  STSStringUtils.h
//
//  Created by Szymon Tomasz Stefanek on 7/2/18.
//  Copyright © 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STSStringIsNullOrEmpty(str) ((!str) || (str.length < 1))

#define STSStringEqualOrBothEmpty(str1,str2) \
	( \
		(str1 && str2 && [str1 isEqualToString:str2]) || \
		( \
			((!str1) || (str1.length < 1)) && \
			((!str2) || (str2.length < 1)) \
		) \
	)


@interface STSStringUtils : NSObject

@end
