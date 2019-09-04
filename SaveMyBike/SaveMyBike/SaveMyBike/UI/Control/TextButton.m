//
//  Created by Szymon Tomasz Stefanek on 20/06/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "TextButton.h"

#import "Config.h"

@implementation TextButton

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	[self setBackgroundColor:[Config instance].highlight1Color forState:STSButtonStateNormal];
	[self setTextColor:[Config instance].generalBackgroundColor forState:STSButtonStateNormal];

	return self;
}

@end
