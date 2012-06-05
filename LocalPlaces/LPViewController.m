//
//  LPViewController.m
//  LocalPlaces
//
//  Created by Luke Lovett on 6/4/12.
//  Copyright (c) 2012 Applaud, Inc. All rights reserved.
//

#import "LPViewController.h"
#import "LPAnnotation.h"

@implementation LPViewController

@synthesize responseData, searchLocations;

#pragma mark -
#pragma mark Root View Methods

/**
 * This is called when the view unloads. Does some freeing of memory.
 */
- (void)viewDidUnload {
    [locationManager stopUpdatingLocation];
    if ( nil != businessRegion )
        [locationManager stopMonitoringForRegion:businessRegion];
    locationManager = nil;
    responseData = nil;
    googlePlacesConnection = nil;
}

/**
 * What happens when the view is finished loading.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self alertUser:@"Please select your location."];
}

/**
 * Called to initialize the user interface.
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if ( self ) {
        // Create the location manager
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        
        // Set the accuracy of the l.m.
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self findLocation];
        
        // Look for the user's current position
        [locationManager startUpdatingLocation];
        
        // Set up the search locations
        // These are just for testing now.
        searchLocations = [[NSString alloc] initWithFormat:@"%@|%@|%@|%@|%@|%@",
                           kMealDelivery,
                           kMealTakeaway,
                           kFood,
                           kBar,
                           kDentist,
                           kRestaurant];
        
        locationsList = [[NSMutableArray alloc] init];
        
        responseData = [[NSMutableData alloc] init];
        googlePlacesConnection = [[GooglePlacesConnection alloc] initWithDelegate: self];
    }
    
    return self;
}

#pragma mark -
#pragma mark Picker View Methods

/**
 * This is required by the UIPickerViewDataSource protocol. Guess what it does?
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [locationsList count];
}

/**
 * This is required by the UIPickerViewDataSource protocol. Guess what it does?
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

/**
 * This fills in the content to the UIPickerView.
 */
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    GooglePlacesObject *result = [[GooglePlacesObject alloc] init];
    result = [locationsList objectAtIndex:row];
    return result.name;
}

/**
 * This gets called when the user selects a row from the UIPickerView
 */
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    currentBusiness = [locationsList objectAtIndex:row];
    
    // Zoom into that business on the map
    CLLocationCoordinate2D loc = currentBusiness.coordinate;
    [self zoomMapTo:loc];
}

#pragma mark -
#pragma mark Location Manager Delegate Protocol Methods

/**
 * This gets called whenever we get an updated location reading.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {    
    NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
    
    // Ignore cached data
    if (t < -180)
        return;
    
    // Is this our first time loading results for this general geographic area?
    if ( resultsLoaded )
        return;
    resultsLoaded = YES;
    
    // We know where we are now.
    [self foundLocation:newLocation];
}

/**
 * This gets called whever we fail to read our location.
 *
 * TODO: make this alert the user.
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Could not find location: %@", error);
}

/**
 * This gets called whenever the customer leaves the business.
 * At least, this is the goal.
 *
 * TODO: make this alert the user.
 */
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"User has exited the region!");
    [locationManager stopMonitoringForRegion:businessRegion];
    
    // Get ready for potentially new results now.
    resultsLoaded = NO;
}

#pragma mark -
#pragma mark Google Places Connection Delegate Methods

/**
 * This gets called when we get a JSON response back from Google Places.
 * This method causes the Picker View to refresh with the new results.
 */
- (void)googlePlacesConnection:(GooglePlacesConnection *)connection didFinishLoadingWithGooglePlacesObjects:(NSMutableArray *)objects {
    // Update locations list
    locationsList = objects;
    [locationSelect reloadAllComponents];
    
    // Point them all out on the map
    for ( GooglePlacesObject *gpo in locationsList ) {
        [worldView addAnnotation:[[LPAnnotation alloc] initWithCoordinate:gpo.coordinate 
                                                                    title:gpo.name
                                                                 subtitle:[gpo.type objectAtIndex:0]]];
    }
}

/**
 * This gets called when Google Places FAILS us!
 * 
 * TODO: Get a bigger quota on the number of requests we can make daily to Google Places.
 * Also, make this alert the user as well??
 */
- (void)googlePlacesConnection:(GooglePlacesConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
}

#pragma mark -
#pragma mark Interface Action Methods

/**
 * What happens when the user hits 'OK'
 */
- (IBAction)selectLocation:(id)sender {
    if ( [locationsList count] == 0 )
        return;
    currentBusiness = [locationsList objectAtIndex:[locationSelect selectedRowInComponent:0]];
    if ( nil != currentBusiness ){
        NSLog(@"The user has entered %@.",currentBusiness.name);
    } else {
        [self alertUser:@"Please select your location."];
    }
}

#pragma mark -
#pragma mark Map View Delegate Methods

/**
 * This gets called when the user's location changes. This is part of the
 * MKMapViewDelegate protocol.
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    // Find where our new location is
    CLLocationCoordinate2D center = [userLocation coordinate];
    
    // Zoom to that location in the MKMapView
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, 
                                                                   BUSINESS_RADIUS_ENTRY, 
                                                                   BUSINESS_RADIUS_ENTRY);
    [worldView setRegion:region animated:YES];
    
}

/**
 * This returns the appropriate MKAnnotationView for a given MKAnnotation.
 * I created a nifty icon representing the user's current location, which appears differently
 * than the icon used to represent businesses. We can create unique icons for each type of business
 * and make this really nice!
 */
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation {
    if ( [annotation.title isEqualToString:@"Your Location"] ) {
        UIImage *currentLocationImage = [UIImage imageNamed:@"mylocation.png"];
        MKAnnotationView *currentLocationView = [[MKAnnotationView alloc] 
                                                 initWithAnnotation:annotation 
                                                 reuseIdentifier:@"Your Location"];
        currentLocationView.image = currentLocationImage;
        return currentLocationView;
    }
    return [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotation.title];
}

#pragma mark -
#pragma mark Other Methods

/**
 * What we do when we want to find a location.
 */
- (void)findLocation {
    [locationManager startUpdatingLocation];
}

/**
 * What we do when we just figured out where we are.
 */
- (void)foundLocation:(CLLocation *)loc {
    // DEBUGGING: see the coordinates of our current location
    CLLocationCoordinate2D place = loc.coordinate;
    // Zoom in
    [self zoomMapTo:place];
    NSLog(@"Current coordinates: (%f, %f)",place.latitude, place.longitude);
    
    // Mark where we are on the map
    LPAnnotation *currentLocation = [[LPAnnotation alloc] initWithCoordinate:place title:@"Your Location"];
    [worldView addAnnotation:currentLocation];
    
    // Create a new region to monitor ("physical bounds of the business")
    businessRegion = [[CLRegion alloc] initCircularRegionWithCenter:place 
                                                             radius:BUSINESS_RADIUS_EXIT
                                                         identifier:@"User Region"];
    [locationManager startMonitoringForRegion:businessRegion];
    
    // Get results from Google Places for the new region.
    [googlePlacesConnection getGoogleObjects:CLLocationCoordinate2DMake(place.latitude,
                                                                        place.longitude) 
                                    andTypes:[self searchLocations]
                                   andRadius:BUSINESS_RADIUS_ENTRY];
}

/**
 * Zoom the map into a particular location.
 */
- (void)zoomMapTo:(CLLocationCoordinate2D)loc {
    // Zoom into the location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 
                                                                   BUSINESS_RADIUS_ENTRY, 
                                                                   BUSINESS_RADIUS_ENTRY);
    [worldView setRegion:region animated:YES];
}

/**
 * A convenience method for showing an alert with just an "OK" button.
 */
- (void)alertUser:(NSString *)msg {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Applaud" 
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
