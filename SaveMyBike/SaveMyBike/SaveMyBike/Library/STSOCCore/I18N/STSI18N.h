#ifndef _STSI18N_h_
#define _STSI18N_h_

//
//  STSI18N.h
//
//  Created by Szymon Tomasz Stefanek on 2/24/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TranslationCenter.h"

NS_INLINE NSString * __tr(NSString * text)
{
	return [[TranslationCenter sharedCenter] translate:text domain:nil];
}

NS_INLINE NSString * __trCtx(NSString * text,NSString * ctx)
{
	return [[TranslationCenter sharedCenter] translate:text context:ctx domain:nil];
}

#define __tr_noop(text)
#define __trCtx_noop(text,ctx)

@interface STSI18N : NSObject

// This can load both *.mo and *.po files.
// It expects the FULL PATH TO THE CATALOG
// You might try something like:
//   [STSI18N loadCatalog:[[NSBundle mainBundle] pathForResource:@"mycatalog-it.po" ofType:nil]];
+ (void)loadCatalog:(NSString *)szPath;

+ (void)unloadCatalog;

@end

#endif //!_STSI18N_h_
