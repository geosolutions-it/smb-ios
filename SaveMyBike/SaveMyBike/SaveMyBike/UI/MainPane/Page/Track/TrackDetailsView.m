//
//  TrackDetailsView.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 22/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "TrackDetailsView.h"

#import "TrackTableCell.h"

#import "STSSingleViewScroller.h"
#import "STSLabel.h"
#import "STSDisplay.h"
#import "STSI18n.h"
#import "STSImageView.h"
#import "STSPair.h"

#import "HealthBenefits.h"
#import "Emissions.h"
#import "Costs.h"

#import "Track.h"

#define VEHICLE_VIEWS 6


@interface TrackDetailsView()
{
	TrackTableCell * m_pUpperCell;
	
	float m_fUpperCellHeight;
	
	STSLabel * m_pDetailsHeaderLabel;
	
	STSSingleViewScroller * m_pBaseScroller;
	
	STSGridLayoutView * m_pBaseGrid;
	
	STSImageView * m_pVehicleView[VEHICLE_VIEWS];
	
	STSLabel * m_pCaloriesConsumedLabel;
	STSLabel * m_pBenefitsIndexLabel;

	STSLabel * m_pFuelLabel;
	STSLabel * m_pDepreciationLabel;
	STSLabel * m_pOperationLabel;
	STSLabel * m_pMovingTimeLabel;
	STSLabel * m_pTotalLabel;

	STSPair<STSLabel *,STSLabel *> * m_pSO2Info;
	STSPair<STSLabel *,STSLabel *> * m_pNOXInfo;
	STSPair<STSLabel *,STSLabel *> * m_pCO2Info;
	STSPair<STSLabel *,STSLabel *> * m_pCOInfo;
	STSPair<STSLabel *,STSLabel *> * m_pPM10Info;
}


@end

@implementation TrackDetailsView

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	STSDisplay * dpy = [STSDisplay instance];
	
	m_pUpperCell = [[TrackTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"default"];
	[self addView:m_pUpperCell row:0 column:0 verticalSizePolicy:STSSizePolicyFixed horizontalSizePolicy:STSSizePolicyIgnore];

	[self _createSeparator:self row:1 col:0 colSpan:1];
	
	m_pDetailsHeaderLabel = [STSLabel new];
	m_pDetailsHeaderLabel.font = [UIFont boldSystemFontOfSize:[dpy centimetersToFontUnits:0.3]];
	m_pDetailsHeaderLabel.textAlignment = NSTextAlignmentCenter;
	m_pDetailsHeaderLabel.text = __trCtx(@"DETAILS",@"TrackDetailsView");
	[self addView:m_pDetailsHeaderLabel row:2 column:0 verticalSizePolicy:STSSizePolicyFixed horizontalSizePolicy:STSSizePolicyIgnore];

	[self _createSeparator:self row:3 col:0 colSpan:1];

	m_pBaseScroller = [STSSingleViewScroller new];
	[self addView:m_pBaseScroller row:4 column:0];

	m_pBaseGrid = [STSGridLayoutView new];
	[m_pBaseScroller setView:m_pBaseGrid];
	[m_pBaseScroller setFillViewport:true];
	
	int r = 0;
	
	
	STSLabel * l = [STSLabel new];
	l.text = __trCtx(@"Vehicles", @"TrackDetailsView");
	[m_pBaseGrid addView:l row:r column:0 verticalSizePolicy:STSSizePolicyFixed horizontalSizePolicy:STSSizePolicyIgnore];
	r++;

	[self _createSeparator:m_pBaseGrid row:r col:0 colSpan:1];
	r++;

	STSGridLayoutView * g = [STSGridLayoutView new];

	int i = 0;
	for(int i=0;i<VEHICLE_VIEWS;i++)
	{
		m_pVehicleView[i] = [STSImageView new];
		m_pVehicleView[i].contentMode = UIViewContentModeScaleAspectFit;
		[g addView:m_pVehicleView[i] row:0 column:i verticalSizePolicy:STSSizePolicyIgnore horizontalSizePolicy:STSSizePolicyIgnore];
		[g setColumn:0 fixedWidth:[dpy centimetersToScreenUnits:0.9]];
	}
	[g setRow:0 fixedHeight:[dpy centimetersToScreenUnits:0.9]];
	[g setColumn:i expandWeight:1000.0];
	[g setSpacing:[dpy centimetersToScreenUnits:0.1]];
	[m_pBaseGrid addView:g row:r column:0 verticalSizePolicy:STSSizePolicyIgnore horizontalSizePolicy:STSSizePolicyIgnore];
	[m_pBaseGrid setRow:r fixedHeight:[dpy centimetersToScreenUnits:0.9]];
	r++;
	
	l = [STSLabel new];
	l.text = __trCtx(@"Health Data", @"TrackDetailsView");
	[m_pBaseGrid addView:l row:r column:0 verticalSizePolicy:STSSizePolicyFixed horizontalSizePolicy:STSSizePolicyIgnore];
	r++;

	[self _createSeparator:m_pBaseGrid row:r col:0 colSpan:1];
	r++;

	g = [STSGridLayoutView new];
	
	int rr = 0;
	m_pCaloriesConsumedLabel = [self _createIconTextValueCell:g row:rr icon:@"small_icon_fire" text:__trCtx(@"Calories Consumed", @"TrackDetailsView")];
	rr += 2;
	m_pBenefitsIndexLabel = [self _createIconTextValueCell:g row:rr icon:@"small_icon_heart_pulse" text:__trCtx(@"Benefits Index", @"TrackDetailsView")];
	rr += 2;

	[g setSpacing:[dpy centimetersToScreenUnits:0.1]];
	
	[m_pBaseGrid addView:g row:r column:0 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyIgnore];
	r++;
	
	


	l = [STSLabel new];
	l.text = __trCtx(@"Emissions and Savings", @"TrackDetailsView");
	[m_pBaseGrid addView:l row:r column:0 verticalSizePolicy:STSSizePolicyFixed horizontalSizePolicy:STSSizePolicyIgnore];
	r++;
	
	[self _createSeparator:m_pBaseGrid row:r col:0 colSpan:1];
	r++;
	
	g = [STSGridLayoutView new];
	
	rr = 0;
	
	STSPair<STSLabel *,STSLabel *> * hdr = [self _createThreeColumnSet:g row:rr text:__trCtx(@"Emission",@"TrackDetailsView")];
	hdr.a.text = __trCtx(@"Value",@"TrackDetailsView");
	hdr.b.text = __trCtx(@"Saved",@"TrackDetailsView");
	rr += 2;

	m_pSO2Info = [self _createThreeColumnSet:g row:rr text:@"SO2"];
	rr += 2;
	m_pNOXInfo = [self _createThreeColumnSet:g row:rr text:@"NOx"];
	rr += 2;
	m_pCOInfo = [self _createThreeColumnSet:g row:rr text:@"CO"];
	rr += 2;
	m_pCO2Info = [self _createThreeColumnSet:g row:rr text:@"CO2"];
	rr += 2;
	m_pPM10Info = [self _createThreeColumnSet:g row:rr text:@"PM10"];
	rr += 2;

	[g setSpacing:[dpy centimetersToScreenUnits:0.1]];
	
	[m_pBaseGrid addView:g row:r column:0 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyIgnore];
	r++;

	
	
	l = [STSLabel new];
	l.text = __trCtx(@"Costs", @"TrackDetailsView");
	[m_pBaseGrid addView:l row:r column:0 verticalSizePolicy:STSSizePolicyFixed horizontalSizePolicy:STSSizePolicyIgnore];
	r++;
	
	[self _createSeparator:m_pBaseGrid row:r col:0 colSpan:1];
	r++;
	
	g = [STSGridLayoutView new];
	
	rr = 0;
	m_pFuelLabel = [self _createIconTextValueCell:g row:rr icon:@"small_icon_fuel" text:__trCtx(@"Fuel", @"TrackDetailsView")];
	rr += 2;
	m_pDepreciationLabel = [self _createIconTextValueCell:g row:rr icon:@"small_icon_directions_car" text:__trCtx(@"Depreciation", @"TrackDetailsView")];
	rr += 2;
	m_pOperationLabel = [self _createIconTextValueCell:g row:rr icon:@"small_icon_trending_top" text:__trCtx(@"Operation", @"TrackDetailsView")];
	rr += 2;
	m_pMovingTimeLabel = [self _createIconTextValueCell:g row:rr icon:@"small_icon_access_time" text:__trCtx(@"Moving Time", @"TrackDetailsView")];
	rr += 2;
	m_pTotalLabel = [self _createIconTextValueCell:g row:rr icon:@"small_icon_euro" text:__trCtx(@"Total", @"TrackDetailsView")];
	rr += 2;

	[g setSpacing:[dpy centimetersToScreenUnits:0.1]];
	
	[m_pBaseGrid addView:g row:r column:0 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyIgnore];
	r++;

	
	
	[m_pBaseGrid setRow:r expandWeight:1000.0];
	[m_pBaseGrid setMargin:[dpy centimetersToScreenUnits:0.2]];
	[m_pBaseGrid setSpacing:[dpy centimetersToScreenUnits:0.1]];

	[self setSpacing:[dpy centimetersToScreenUnits:0.1]];
	[self setRow:4 expandWeight:1000.0];
	
	m_fUpperCellHeight = -1.0;
	
	self.backgroundColor = [UIColor whiteColor];
	
	return self;
}

- (STSPair<STSLabel *,STSLabel *> *)_createThreeColumnSet:(STSGridLayoutView *)g row:(int)r text:(NSString *)sText
{
	STSDisplay * dpy = [STSDisplay instance];
	
	STSPair<STSLabel *,STSLabel *> * pair = [STSPair new];
	
	STSLabel * l1 = [STSLabel new];
	l1.text = sText;
	[g addView:l1 row:r column:0 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyCanExpand];
	
	STSLabel * l2 = [STSLabel new];
	l2.textAlignment = NSTextAlignmentCenter;
	[g addView:l2 row:r column:1 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyCanExpand];

	STSLabel * l3 = [STSLabel new];
	l3.text = @"---";
	l3.textAlignment = NSTextAlignmentRight;
	[g addView:l3 row:r column:2 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyCanExpand];
	
	[g setRow:r fixedHeight:[dpy centimetersToScreenUnits:0.9]];
	[g setColumn:0 minimumWidth:[dpy centimetersToScreenUnits:1.5]];
	[g setColumn:1 expandWeight:1000.0];
	[g setColumn:2 minimumWidth:[dpy centimetersToScreenUnits:1.5]];
	
	[self _createLightSeparator:g row:r+1 col:0 colSpan:3];
	
	pair.a = l2;
	pair.b = l3;
	
	return pair;
}


- (STSLabel *)_createIconTextValueCell:(STSGridLayoutView *)g row:(int)r icon:(NSString *)sIcon text:(NSString *)sText
{
	STSDisplay * dpy = [STSDisplay instance];
	
	STSImageView * img = [STSImageView new];
	img.contentMode = UIViewContentModeScaleAspectFit;
	img.image = [UIImage imageNamed:sIcon];
	[g addView:img row:r column:0 verticalSizePolicy:STSSizePolicyIgnore horizontalSizePolicy:STSSizePolicyIgnore];
	[g setView:img margins:[STSMargins marginsWithAllValues:[dpy centimetersToScreenUnits:0.1]]];

	STSLabel * l = [STSLabel new];
	l.text = sText;
	[g addView:l row:r column:1 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyIgnore];

	STSLabel * l2 = [STSLabel new];
	l2.text = @"---";
	l2.textAlignment = NSTextAlignmentRight;
	[g addView:l2 row:r column:2 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyCanExpand];

	[g setRow:r fixedHeight:[dpy centimetersToScreenUnits:0.8]];
	[g setColumn:0 fixedWidth:[dpy centimetersToScreenUnits:0.8]];
	[g setColumn:1 expandWeight:1000.0];
	[g setColumn:2 minimumWidth:[dpy centimetersToScreenUnits:1.5]];
	
	[self _createLightSeparator:g row:r+1 col:0 colSpan:3];
	
	return l2;
}

- (void)_createSeparator:(STSGridLayoutView *)g row:(int)r col:(int)c colSpan:(int)cs
{
	UIView * v = [UIView new];
	v.backgroundColor = [UIColor lightGrayColor];
	
	[g addView:v row:r column:c rowSpan:1 columnSpan:cs verticalSizePolicy:STSSizePolicyIgnore horizontalSizePolicy:STSSizePolicyIgnore];
	[g setRow:r fixedHeight:1];
}

- (void)_createLightSeparator:(STSGridLayoutView *)g row:(int)r col:(int)c colSpan:(int)cs
{
	UIView * v = [UIView new];
	v.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
	
	[g addView:v row:r column:c rowSpan:1 columnSpan:cs verticalSizePolicy:STSSizePolicyIgnore horizontalSizePolicy:STSSizePolicyIgnore];
	[g setRow:r fixedHeight:1];
}

- (float)headerHeight
{
	if(m_fUpperCellHeight < 0.0)
		m_fUpperCellHeight = [m_pUpperCell intrinsicContentSize].height;
	return m_fUpperCellHeight;
}

- (void)setupForTrack:(Track *)trk
{
	[m_pUpperCell setupForTrack:trk];
	
	int i = 0;
	for(NSString * sV in trk.vehicleTypes)
	{
		UIImage * img = [UIImage imageNamed:[NSString stringWithFormat:@"track_stats_%@",sV]];
		m_pVehicleView[i].image = img ? img : [UIImage imageNamed:@"track_stats_car"];
		i++;
		if(i >= VEHICLE_VIEWS)
			break;
	}

	m_pCaloriesConsumedLabel.text = trk.health ? [NSString stringWithFormat:@"%.0f cal",trk.health.calories_consumed] : @"?";
	m_pBenefitsIndexLabel.text = trk.health ? [NSString stringWithFormat:@"%.0f",trk.health.benefit_index] : @"?";
	
	m_pFuelLabel.text = trk.costs ? [NSString stringWithFormat:@"%f €",trk.costs.fuelCost] : @"?";
	m_pDepreciationLabel.text = trk.costs ? [NSString stringWithFormat:@"%f €",trk.costs.depreciationCost] : @"?";
	m_pOperationLabel.text = trk.costs ? [NSString stringWithFormat:@"%f €",trk.costs.operationCost] : @"?";
	m_pMovingTimeLabel.text = trk.costs ? [NSString stringWithFormat:@"%f €",trk.costs.timeCost] : @"?";
	m_pTotalLabel.text = trk.costs ? [NSString stringWithFormat:@"%f €",trk.costs.totalCost] : @"?";
	
	m_pSO2Info.a.text = trk.emissions ? [self formatWeightedQuantity:trk.emissions.so2] : @"?";
	m_pSO2Info.b.text = trk.emissions ? [self formatWeightedQuantity:trk.emissions.so2_saved] : @"?";
	m_pCO2Info.a.text = trk.emissions ? [self formatWeightedQuantity:trk.emissions.co2] : @"?";
	m_pCO2Info.b.text = trk.emissions ? [self formatWeightedQuantity:trk.emissions.co2_saved] : @"?";
	m_pCOInfo.a.text = trk.emissions ? [self formatWeightedQuantity:trk.emissions.co] : @"?";
	m_pCOInfo.b.text = trk.emissions ? [self formatWeightedQuantity:trk.emissions.co_saved] : @"?";
	m_pNOXInfo.a.text = trk.emissions ? [self formatWeightedQuantity:trk.emissions.nox] : @"?";
	m_pNOXInfo.b.text = trk.emissions ? [self formatWeightedQuantity:trk.emissions.nox_saved] : @"?";
	m_pPM10Info.a.text = trk.emissions ? [self formatWeightedQuantity:trk.emissions.pm10] : @"?";
	m_pPM10Info.b.text = trk.emissions ? [self formatWeightedQuantity:trk.emissions.pm10_saved] : @"?";

}

- (NSString *)formatWeightedQuantity:(double)dVal
{
	if(dVal < 0.001)
		return [NSString stringWithFormat:@"%.0f ug",dVal * 1000000.0];
	if(dVal < 1.0)
		return [NSString stringWithFormat:@"%.0f mg",dVal * 1000.0];
	if(dVal < 1000.0)
		return [NSString stringWithFormat:@"%.0f g",dVal];
	return [NSString stringWithFormat:@"%.1f kg",dVal / 1000.0];
}


@end
