//
//  STSSimpleTableViewCellWithImageAndTwoLabels.m
//
//  Created by Szymon Tomasz Stefanek on 7/2/18.
//  Copyright © 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSimpleTableViewCellWithImageAndTwoLabels.h"

#import "STSDisplay.h"


@implementation STSSimpleTableViewCellWithImageAndTwoLabels
{
}

//@dynamic imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
	if(!self)
		return nil;
	
	STSDisplay * dpy = [STSDisplay instance];

	STSGridLayoutView * g = self.grid;

	self.iconView = [STSImageView new];
	self.iconView.contentMode = UIViewContentModeScaleAspectFit;
	

	[g addView:self.iconView row:0 column:0 rowSpan:2 columnSpan:1 verticalSizePolicy:STSSizePolicyIgnore horizontalSizePolicy:STSSizePolicyIgnore];


	[g setColumn:0 fixedWidth:[dpy centimetersToScreenUnits:0.8]];

	self.upperLabel = [STSLabel new];
	self.upperLabel.font = [UIFont systemFontOfSize:[dpy centimetersToFontUnits:0.4]];
	//self.upperLabel.textColor = [UIColor blueColor];
	//self.upperLabel.text = @"erwqieoq wieqp oeio ewq eipqw";
	//self.upperLabel.numberOfLines = 1;
	//self.upperLabel.lineBreakMode = NSLineBreakByTruncatingTail;
	//self.upperLabel.adjustsFontSizeToFitWidth = NO;
	[g addView:self.upperLabel row:0 column:1 rowSpan:1 columnSpan:1 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyIgnore];
	
	self.lowerLabel = [STSLabel new];
	self.lowerLabel.font = [UIFont systemFontOfSize:[dpy centimetersToFontUnits:0.25]];
	//self.lowerLabel.numberOfLines = 1;
	//self.lowerLabel.lineBreakMode = NSLineBreakByTruncatingTail;
	//self.lowerLabel.adjustsFontSizeToFitWidth = NO;
	[g addView:self.lowerLabel row:1 column:1 rowSpan:1 columnSpan:1 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyIgnore];

	[g setMargin:[dpy centimetersToScreenUnits:0.1f]];
	[g setSpacing:[dpy centimetersToScreenUnits:0.1f]];
	
	return self;
}


@end
