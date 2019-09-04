//
//  STSMessageBox.h
//
//  Created by Szymon Tomasz Stefanek on 1/24/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class STSMessageBoxParams;

@protocol STSMessageBoxDelegate<NSObject>

- (void)messageBox:(STSMessageBoxParams *)pParams dismissedWithButton:(int)iIndex;

@end

@interface STSMessageBoxParams : NSObject

	@property(nonatomic) NSString * tag;

	@property(nonatomic) NSString * title;
	@property(nonatomic) NSString * message;
	@property(nonatomic) UIImage * image;

	@property(nonatomic) NSString * button0Text;
	@property(nonatomic) NSString * button1Text;
	@property(nonatomic) NSString * button2Text;
	@property(nonatomic) NSString * button3Text;

	// You can use the delegate
	@property(nonatomic) id<STSMessageBoxDelegate> delegate;
	// OR the block
	@property(nonatomic) void (^callback)(STSMessageBoxParams *pParams,int iButtonIdx);

	// If you leave this nil the current controller will be used (so don't bother)
	@property(nonatomic) UIViewController * controller;

	// out
	@property(nonatomic) UIAlertController * alertController;

@end


@interface STSMessageBox : NSObject

+ (void)showWithMessage:(NSString *)szMessage;
+ (void)showWithMessage:(NSString *)szMessage title:(NSString *)szTitle;
+ (void)showWithMessage:(NSString *)szMessage title:(NSString *)szTitle buttonText:(NSString *)szButtonText;

+ (void)showFromController:(UIViewController *)pController message:(NSString *)szMessage;
+ (void)showFromController:(UIViewController *)pController message:(NSString *)szMessage title:(NSString *)szTitle;
+ (void)showFromController:(UIViewController *)pController message:(NSString *)szMessage title:(NSString *)szTitle buttonText:(NSString *)szButtonText;

+ (void)show:(STSMessageBoxParams *)pParams;

@end
