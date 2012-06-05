//
//  LPAnnotation.m
//  LocalPlaces
//
//  Created by Luke Lovett on 6/5/12.
//  Copyright (c) 2012 Applaud, Inc. All rights reserved.
//

#import "LPAnnotation.h"

@implementation LPAnnotation

@synthesize coordinate, title, subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)tit subtitle:(NSString *)subtit {
    self = [super init];
    
    if (self) {
        coordinate = coord;
        [self setTitle:tit];
        [self setSubtitle:subtit];
    }
    
    return self;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)tit {
    return [self initWithCoordinate:coordinate title:tit subtitle:@""];
}

@end
