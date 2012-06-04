//
//  LPAppDelegate.h
//  LocalPlaces
//
//  Created by Luke Lovett on 6/4/12.
//  Copyright (c) 2012 Oberlin College. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPViewController;

@interface LPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LPViewController *viewController;

@end
