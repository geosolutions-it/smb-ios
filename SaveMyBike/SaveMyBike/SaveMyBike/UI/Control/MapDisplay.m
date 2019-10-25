//
//  MapDisplay.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 20/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "MapDisplay.h"

#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>

#import "STSGeoCoordinate.h"
#import "STSLatLongBoundingBox.h"
#import "STSDisplay.h"

#import "STSGeoJSONObject.h"
#import "STSGeoCoordinate.h"

#import "STSCore.h"


@interface MapDisplay()<GMSAutocompleteResultsViewControllerDelegate,UISearchBarDelegate>
{
	GMSMapView * m_pMapView;
	UISearchBar * m_pSearchBar;
	NSMutableArray<GMSOverlay *> * m_pOverlays;
	
	UISearchController * m_pSearchController;
	GMSAutocompleteResultsViewController * m_pAutocompleteResultsViewController;
}
@end


@implementation MapDisplay


- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	m_pOverlays = [NSMutableArray new];
	
	GMSCameraPosition * c = [GMSCameraPosition cameraWithLatitude:43.3182200 longitude:11.3306400 zoom:10];
	
	m_pMapView = [GMSMapView mapWithFrame:CGRectZero camera:c];
	
	[self addView:m_pMapView row:0 column:0 rowSpan:3 columnSpan:3];
	
	STSDisplay * dpy = [STSDisplay instance];
	
	[self setRow:0 fixedHeight:[dpy centimetersToScreenUnits:0.1]];
	[self setColumn:0 fixedWidth:[dpy centimetersToScreenUnits:0.1]];
	[self setColumn:2 fixedWidth:[dpy centimetersToScreenUnits:0.1]];
	[self setRow:2 expandWeight:1000.0];
	[self setColumn:1 expandWeight:1000.0];
	
	return self;
}

- (GMSMapView *)mapView
{
	return m_pMapView;
}

- (void)enableMyLocationButton
{
	m_pMapView.myLocationEnabled = true;
	m_pMapView.settings.myLocationButton = true;
}

- (void)enableSearchBox
{
	
	m_pAutocompleteResultsViewController = [[GMSAutocompleteResultsViewController alloc] init];
	m_pAutocompleteResultsViewController.delegate = self;
	
	m_pSearchController = [[UISearchController alloc] initWithSearchResultsController:m_pAutocompleteResultsViewController];
	m_pSearchController.searchResultsUpdater = m_pAutocompleteResultsViewController;
	[self addView:m_pSearchController.searchBar row:1 column:1];
	
	
	m_pSearchController.hidesNavigationBarDuringPresentation = false;
	m_pSearchController.modalPresentationStyle = UIModalPresentationPopover;
	
	//self.definesPresentationContext = true
	
	m_pSearchController.searchBar.delegate = self;
	
}

- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController didAutocompleteWithPlace:(GMSPlace *)place
{
	m_pSearchController.active = false;
	[m_pMapView animateToLocation:place.coordinate];
}

- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController didFailAutocompleteWithError:(NSError *)error
{
	STS_CORE_LOG(@"Search error: %@",error.localizedDescription);
}

- (void)didRequestAutocompletePredictionsForResultsController:(GMSAutocompleteResultsViewController *)resultsController
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = true;
}

- (void)didUpdateAutocompletePredictionsForResultsController:(GMSAutocompleteResultsViewController *)resultsController
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = false;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[m_pSearchBar resignFirstResponder];
	m_pSearchController.active = FALSE;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[m_pSearchBar resignFirstResponder];
}

- (void)removeAllOverlays
{
	for(GMSOverlay * o in m_pOverlays)
		o.map = nil;
	[m_pOverlays removeAllObjects];
}

- (void)addMarkerWithLatitude:(double)lat longitude:(double)lon title:(NSString *)szTitle andDescription:(NSString *)szDescription
{
	GMSMarker * m = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(lat,lon)];
	
	m.title = szTitle;
	m.snippet = szDescription;
	
	m.map = m_pMapView;
	
	[m_pOverlays addObject:m];
}

- (void)animateToLatitude:(double)lat longitude:(double)lon zoom:(double)z
{
	GMSCameraPosition * c = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:z];
	
	m_pMapView.camera = c;
}

- (void)animateTo:(GMSCoordinateBounds *)bnds
{
	GMSCameraPosition * c = [m_pMapView cameraForBounds:bnds insets:UIEdgeInsetsMake(20, 20, 20, 20)];
	
	m_pMapView.camera = c;
	
	//GMSCameraUpdate * up = [GMSCameraUpdate fitBounds:bnds withPadding:20.0];
	
	//[m_pMapView animateWithCameraUpdate:up];
}

- (void)animateToBoundingBox:(STSLatLongBoundingBox *)box
{
	GMSCoordinateBounds * bnds = [[GMSCoordinateBounds alloc] initWithCoordinate:CLLocationCoordinate2DMake(box.north,box.east) coordinate:CLLocationCoordinate2DMake(box.south,box.west)];
	[self animateTo:bnds];
}


- (void)createPathForPoints:(NSMutableArray<STSGeoCoordinate *> *)coords
{
	GMSMutablePath * mp = [GMSMutablePath new];

	for(STSGeoCoordinate * c in coords)
	{
		[mp addCoordinate:CLLocationCoordinate2DMake(c.latitude,c.longitude)];
	}
	
	GMSPolyline * pl = [GMSPolyline polylineWithPath:mp];
	pl.strokeColor = [UIColor blueColor];
	pl.strokeWidth = 2.0;
	pl.map = m_pMapView;

	[m_pOverlays addObject:pl];
}



@end
