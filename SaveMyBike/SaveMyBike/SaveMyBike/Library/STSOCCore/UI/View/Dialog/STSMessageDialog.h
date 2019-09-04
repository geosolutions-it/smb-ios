//
//  STSMessageDialog.h
//
//  Created by Szymon Tomasz Stefanek on 3/5/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSDialog.h"

@class STSLabel;

@interface STSMessageDialog : STSDialog

@property(nonatomic,readonly) STSLabel * label;
@property(nonatomic) NSString * text;

+ (STSMessageDialog *)dialogWithMessage:(NSString *)szMessage;
+ (STSMessageDialog *)dialogWithMessage:(NSString *)szMessage delegate:(id<STSDialogDelegate>)pDelegate;
+ (STSMessageDialog *)dialogWithMessage:(NSString *)szMessage title:(NSString *)szTitle;
+ (STSMessageDialog *)dialogWithMessage:(NSString *)szMessage title:(NSString *)szTitle delegate:(id<STSDialogDelegate>)pDelegate;
+ (STSMessageDialog *)dialogWithMessage:(NSString *)szMessage title:(NSString *)szTitle buttonText:(NSString *)szButton1Text buttonTag:(NSString *)szButton1Tag;
+ (STSMessageDialog *)dialogWithMessage:(NSString *)szMessage title:(NSString *)szTitle buttonText:(NSString *)szButton1Text buttonTag:(NSString *)szButton1Tag delegate:(id<STSDialogDelegate>)pDelegate;
+ (STSMessageDialog *)dialogWithMessage:(NSString *)szMessage title:(NSString *)szTitle button1Text:(NSString *)szButton1Text button1Tag:(NSString *)szButton1Tag button2Text:(NSString *)szButton2Text button2Tag:(NSString *)szButton2Tag;
+ (STSMessageDialog *)dialogWithMessage:(NSString *)szMessage title:(NSString *)szTitle button1Text:(NSString *)szButton1Text button1Tag:(NSString *)szButton1Tag button2Text:(NSString *)szButton2Text button2Tag:(NSString *)szButton2Tag delegate:(id<STSDialogDelegate>)pDelegate;
+ (STSMessageDialog *)dialogWithMessage:(NSString *)szMessage title:(NSString *)szTitle button1Text:(NSString *)szButton1Text button1Tag:(NSString *)szButton1Tag button2Text:(NSString *)szButton2Text button2Tag:(NSString *)szButton2Tag button3Text:(NSString *)szButton3Text button3Tag:(NSString *)szButton3Tag;
+ (STSMessageDialog *)dialogWithMessage:(NSString *)szMessage title:(NSString *)szTitle button1Text:(NSString *)szButton1Text button1Tag:(NSString *)szButton1Tag button2Text:(NSString *)szButton2Text button2Tag:(NSString *)szButton2Tag button3Text:(NSString *)szButton3Text button3Tag:(NSString *)szButton3Tag delegate:(id<STSDialogDelegate>)pDelegate;

@end
