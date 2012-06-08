//
//  AppDelegate.m
//  Survey
//
//  Created by Peter Fogg on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "Survey.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
  MasterViewController *masterController = [navController.viewControllers objectAtIndex:0];
  NSMutableArray *surveys = [[NSMutableArray alloc] init];
  NSURL *url = [NSURL URLWithString:@"http://weapplaudyou.com/testapp/survey-data"];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  [NSURLConnection sendAsynchronousRequest:request
									 queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse *rep, NSData *d, NSError *err) {
                           if(err) {
                             NSLog(@"%@", err);
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error getting survey data."
                                                                             message:@""
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                             [alert show];
                             return;
                           }
                           if(d) {
                             NSMutableArray *allSurveys = [NSJSONSerialization JSONObjectWithData:d
                                                                                          options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves
                                                                                            error:nil];
                             for(NSMutableArray *item in allSurveys) {
                               NSString *title = [item objectAtIndex:[item count] - 1];
                               [item removeLastObject];
                               Survey *survey = [[Survey alloc] initWithArray:item title:title];
                               [surveys addObject:survey];
                             }
                             masterController.surveys = surveys;
                             dispatch_async(dispatch_get_main_queue(), ^{
								 [masterController.tableView reloadData];
							   });
                           }
	}];
  
  // TODO: worth thinking about synchronization issues -- what if we receive data when things are happening?
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  
}

@end
