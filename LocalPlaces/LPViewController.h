//
//  LPViewController.h
//  LocalPlaces
//
//  Created by Luke Lovett on 6/4/12.
//  Copyright (c) 2012 Applaud, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "GooglePlacesConnection.h"

// This defines our range for selecting possible businesses the customer may be patronizing now.
#define BUSINESS_RADIUS_ENTRY 250
// This defines how far the customer can be away from our record of the location of the business
// before we consider the cusomter to have left.
#define BUSINESS_RADIUS_EXIT 1000

@interface LPViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, GooglePlacesConnectionDelegate, UIAlertViewDelegate> {
    IBOutlet MKMapView *worldView;
    IBOutlet UIPickerView *locationSelect;
    
    // Manages a connection to Google Places
    GooglePlacesConnection *googlePlacesConnection;
    
    // This will be filled with nearby businesses
    NSMutableArray *locationsList;
    
    // Whether or not we have loaded local business results
    BOOL resultsLoaded;
    // The region that defines the current business
    CLRegion *businessRegion;
    // Google Places result that matches where the user is right now
    GooglePlacesObject *currentBusiness;
     
    CLLocationManager *locationManager;
}

// Raw data from queries to Google Places
@property (nonatomic, retain) NSMutableData *responseData;
// This holds what kinds of businesses we want to chart
@property (nonatomic, retain) NSString *searchLocations;

- (void)findLocation;
- (void)foundLocation:(CLLocation *)loc;
- (void)zoomMapTo:(CLLocationCoordinate2D)loc;
- (void)alertUser:(NSString *)msg;

// Hitting the "OK" button
- (IBAction)selectLocation:(id)sender;

@end
