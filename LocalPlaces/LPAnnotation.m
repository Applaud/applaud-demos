//
//  LPAnnotation.m
//  LocalPlaces
//
//  Created by Luke Lovett on 6/5/12.
//  Copyright (c) 2012 Applaud, Inc. All rights reserved.
//

#import "LPAnnotation.h"

@implementation LPAnnotation

@synthesize coordinate, title;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)tit {
    self = [super init];
    
    if (self) {
        coordinate = coord;
        [self setTitle:tit];
    }
    
    return self;
}

@end
