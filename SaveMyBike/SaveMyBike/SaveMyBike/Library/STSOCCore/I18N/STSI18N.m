//
//  STSI18N.m
//  
//  Created by Szymon Tomasz Stefanek on 2/24/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSI18N.h"

@implementation STSI18N


+ (void)loadCatalog:(NSString *)szPath;
{
	[[TranslationCenter sharedCenter] loadTextDomain:@"main" path:szPath];
}

+ (void)unloadCatalog
{
	[[TranslationCenter sharedCenter] unloadTextDomain:@"main"];
}

@end
