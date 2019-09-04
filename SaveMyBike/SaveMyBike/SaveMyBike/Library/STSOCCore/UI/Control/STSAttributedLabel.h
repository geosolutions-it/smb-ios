//
//  STSAttributedLabel.h
//
//  Created by Szymon Tomasz Stefanek on 8/28/18.
//  Copyright © 2018 Szymon Tomasz Stefanek. All right reserved.
//

#import "STSLabel.h"

#import <UIKit/UIKit.h>

@interface STSAttributedLabel : STSLabel

@property (nonatomic) NSDictionary *boldAttributeDefault;
@property (nonatomic) NSDictionary *linkAttributeDefault;
@property (nonatomic) NSDictionary *linkAttributeHighlight;

- (void)setLinkForRange:(NSRange)range withAttributes:(NSDictionary *)attributes andLinkHandler:(void (^)(STSAttributedLabel *label, NSRange selectedRange))handler;
- (void)setLinkForRange:(NSRange)range withLinkHandler:(void(^)(STSAttributedLabel *label, NSRange selectedRange))handler;

- (void)setLinkForSubstring:(NSString *)substring withAttribute:(NSDictionary *)attribute andLinkHandler:(void(^)(STSAttributedLabel *label, NSString *substring))handler;
- (void)setLinkForSubstring:(NSString *)substring withLinkHandler:(void(^)(STSAttributedLabel *label, NSString *substring))handler;

- (void)setLinksForSubstrings:(NSArray *)substrings withLinkHandler:(void(^)(STSAttributedLabel *label, NSString *substring))handler;

- (void)setBoldForRange:(NSRange)range;
- (void)setBoldForSubstring:(NSString *)substring;

- (void)clearActionDictionary;

- (void)setAttributesForRange:(NSRange)range withAttributes:(NSDictionary *)attributes;


@end
