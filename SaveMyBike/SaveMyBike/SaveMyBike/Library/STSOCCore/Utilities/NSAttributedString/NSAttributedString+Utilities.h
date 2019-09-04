//
//  NSAttributedString(Utilities).h
//  
//  Created by Szymon Tomasz Stefanek on 2/26/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString(Utilities)

- (NSAttributedString *)attributedStringByTrimmingCharactersInSet:(NSCharacterSet *)set;
- (NSAttributedString *)attributedStringByTrimmingWhitespace;

@end

@interface NSMutableAttributedString(Utilities)

- (NSMutableAttributedString *)attributedStringByTrimmingCharactersInSet:(NSCharacterSet *)set;
- (NSMutableAttributedString *)attributedStringByTrimmingWhitespace;

@end
