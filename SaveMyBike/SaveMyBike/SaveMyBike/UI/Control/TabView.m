//
//  TabView.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 08/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "TabView.h"

#import "Config.h"

#import "STSDisplay.h"

@implementation TabView

- (id)initWithTabsAbove:(bool)bAbove
{
	self = [super initWithTabsAbove:bAbove];
	if(!self)
		return nil;
	
	STSDisplay * dpy = [STSDisplay instance];
	
	self.segmentedControl.selectionIndicatorColor = [Config instance].highlight1Color;
	//self.segmentedControl.selectionIndicatorBoxColor = [Config instance].highlight1Color;
	self.segmentedControl.verticalDividerColor = [Config instance].highlight1Color;
	self.segmentedControl.selectionIndicatorBoxOpacity = 1.0;
	//self.segmentedControl.verticalDividerWidth = 1.0;
	self.segmentedControl.verticalDividerEnabled = false;
	//self.segmentedControl.type = STSSegmentedControlType;
	self.segmentedControl.selectionStyle = STSSegmentedControlSelectionStyleFullWidthStripe;
	//self.segmentedControl.segmentWidthStyle = STSSegmentedControlSelectionStyleFullWidthStripe;
	self.segmentedControl.selectionIndicatorLocation = bAbove ? STSSegmentedControlSelectionIndicatorLocationUp : STSSegmentedControlSelectionIndicatorLocationDown;

	NSMutableDictionary * dict = [NSMutableDictionary new];

	[dict setValue:[Config instance].highlight1Color forKey:NSForegroundColorAttributeName];
	self.segmentedControl.selectedTitleTextAttributes = dict;
	
	//@property (nonatomic, strong) NSDictionary *titleTextAttributes UI_APPEARANCE_SELECTOR;
	//@property (nonatomic, strong) NSDictionary *selectedTitleTextAttributes UI_APPEARANCE_SE
	//@property (nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;
	
	self.segmentedControl.borderType = STSSegmentedControlBorderTypeNone;
	self.segmentedControl.userDraggable = false;
	self.segmentedControl.touchEnabled = true;
	self.segmentedControl.selectionIndicatorHeight = [dpy centimetersToScreenUnits:0.1];
	self.segmentedControl.shouldAnimateUserSelection = true;
	//float m = [dpy centimetersToScreenUnits:0.1];
	//self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(m,m,m,m);
	//self.segmentedControl.enlargeEdgeInset = UIEdgeInsetsMake(m,m,m,m);

	self.segmentedControl.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
	
	return self;
}


@end
