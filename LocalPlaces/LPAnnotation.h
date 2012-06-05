//
//  LPAnnotation.h
//  LocalPlaces
//
//  Created by Luke Lovett on 6/5/12.
//  Copyright (c) 2012 Applaud, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LPAnnotation : NSObject <MKAnnotation>

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString*)tit;

// This is required to conform to the MKAnnotation protocol
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

// An optional property from the MKAnnotation protocol
@property (nonatomic, copy) NSString *title;

@end
