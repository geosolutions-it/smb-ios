//
//  STSMessageDialog.m
//
//  Created by Szymon Tomasz Stefanek on 3/5/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSMessageDialog.h"

#import "STSLabel.h"
#import "STSDisplay.h"

@interface STSMessageDialog()
{
	STSLabel * m_pLabel;
}

@end

@implementation STSMessageDialog

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	m_pLabel = [STSLabel new];
	m_pLabel.textAlignment = NSTextAlignmentCenter;
	m_pLabel.lineBreakMode = NSLineBreakByWordWrapping;
	
	[self setCentralView:m_pLabel verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyCanShrinkAndExpand];
	
	[self setCentralViewMinimumWidth:[[STSDisplay instance] minorScreenDimensionFractionToScreenUnits:0.5]];
	[self setCentralViewMaximumWidth:[[STSDisplay instance] minorScreenDimensionFractionToScreenUnits:0.9]];
	[self setCentralViewMinimumHeight:[[STSDisplay instance] centimetersToScreenUnits:2.0]];
	
	return self;
}

- (STSLabel *)label
{
	return m_pLabel;
}

- (NSString *)text
{
	return m_pLabel.text;
}

- (void)setText:(NSString *)text
{
	m_pLabel.text = text;
}

+ (STSMessageDialog *)dialogWithMessage:(NSString *)szMessage
{
	return [STSMessageDialog dialogWithMessage:szMessage delegate:nil];
}

+ (STSMessageDialog *)dialogWithMessage:(NSString *)szMessage delegate:(id<STSDialogDelegate>)pDelegate
{
	STSMessageDialog * dlg = [STSMessageDialog new];
	dlg.text = szMessage;
	if(pDelegate)
		[dlg setDelegate:pDelegate];
	[dlg addButton:@"OK" tag:@"ok"];
	return dlg;
}

+ (STSMessageDialog *)dialogWithMessage:(NSString *)szMessage title:(NSString *)szTitle
{
	return [STSMessageDialog dialogWithMessage:szMessage title:szTitle delegate:nil];
}

+ (STSMessageDialog *)dialogWithMessage:(NSString *)szMessage title:(NSString *)szTitle delegate:(id<STSDialogDelegate>)pDelegate
{
	STSMessageDialog * dlg = [STSMessageDialog new];
	dlg.text = szMessage;
	[dlg setTitle:szTitle];
	[dlg addButton:@"OK" tag:@"ok"];
	if(pDelegate)
		[dlg setDelegate:pDelegate];
	return dlg;
}

+ (STSMessageDialog *)dialogWithMessage:(NSString *)szMessage title:(NSString *)szTitle buttonText:(NSString *)szButton1Text buttonTag:(NSString *)szButton1Tag
{
	return [STSMessageDialog dialogWithMessage:szMessage title:szTitle buttonText:szButton1Text buttonTag:szButton1Tag delegate:nil];
}

+ (STSMessageDialog *)dialogWithMessage:(NSString *)szMessage title:(NSString *)szTitle buttonText:(NSString *)szButton1Text buttonTag:(NSString *)szButton1Tag delegate:(id<STSDialogDelegate>)pDelegate
{
	STSMessageDialog * dlg = [STSMessageDialog new];
	dlg.text = szMessage;
	[dlg setTitle:szTitle];
	[dlg addButton:szButton1Text tag:szButton1Tag];
	if(pDelegate)
		[dlg setDelegate:pDelegate];
	return dlg;
}

+ (STSMessageDialog *)dialogWithMessage:(NSString *)szMessage title:(NSString *)szTitle button1Text:(NSString *)szButton1Text button1Tag:(NSString *)szButton1Tag button2Text:(NSString *)szButton2Text button2Tag:(NSString *)szButton2Tag
{
	return [STSMessageDialog dialogWithMessage:szMessage title:szTitle button1Text:szButton1Text button1Tag:szButton1Tag button2Text:szButton2Text button2Tag:szButton2Tag delegate:nil];
}

+ (STSMessageDialog *)dialogWithMessage:(NSString *)szMessage title:(NSString *)szTitle button1Text:(NSString *)szButton1Text button1Tag:(NSString *)szButton1Tag button2Text:(NSString *)szButton2Text button2Tag:(NSString *)szButton2Tag delegate:(id<STSDialogDelegate>)pDelegate
{
	STSMessageDialog * dlg = [STSMessageDialog new];
	dlg.text = szMessage;
	[dlg setTitle:szTitle];
	[dlg addButton:szButton1Text tag:szButton1Tag];
	[dlg addButton:szButton2Text tag:szButton2Tag];
	if(pDelegate)
		[dlg setDelegate:pDelegate];
	return dlg;
}

+ (STSMessageDialog *)dialogWithMessage:(NSString *)szMessage title:(NSString *)szTitle button1Text:(NSString *)szButton1Text button1Tag:(NSString *)szButton1Tag button2Text:(NSString *)szButton2Text button2Tag:(NSString *)szButton2Tag button3Text:(NSString *)szButton3Text button3Tag:(NSString *)szButton3Tag
{
	return [STSMessageDialog dialogWithMessage:szMessage title:szTitle button1Text:szButton1Text button1Tag:szButton1Tag button2Text:szButton2Text button2Tag:szButton2Tag button3Text:szButton3Text button3Tag:szButton3Tag delegate:nil];
}

+ (STSMessageDialog *)dialogWithMessage:(NSString *)szMessage title:(NSString *)szTitle button1Text:(NSString *)szButton1Text button1Tag:(NSString *)szButton1Tag button2Text:(NSString *)szButton2Text button2Tag:(NSString *)szButton2Tag button3Text:(NSString *)szButton3Text button3Tag:(NSString *)szButton3Tag delegate:(id<STSDialogDelegate>)pDelegate
{
	STSMessageDialog * dlg = [STSMessageDialog new];
	dlg.text = szMessage;
	[dlg setTitle:szTitle];
	[dlg addButton:szButton1Text tag:szButton1Tag];
	[dlg addButton:szButton2Text tag:szButton2Tag];
	[dlg addButton:szButton3Text tag:szButton3Tag];
	if(pDelegate)
		[dlg setDelegate:pDelegate];
	return dlg;
}


@end
