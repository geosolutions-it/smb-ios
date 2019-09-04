//
//  STSPopupMenuDelegate.h
//  
//  Created by Szymon Tomasz Stefanek on 3/4/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#ifndef STSPopupMenuDelegate_h
#define STSPopupMenuDelegate_h

@class STSPopupMenu;

@protocol STSPopupMenuDelegate<NSObject>

- (void)popupMenu:(STSPopupMenu *)pMenu itemActivated:(NSString *)szTag;

@end

#endif /* STSPopupMenuDelegate_h */
