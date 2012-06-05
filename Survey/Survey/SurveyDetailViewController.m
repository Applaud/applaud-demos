//
//  SurveyDetailViewController.m
//  Survey
//
//  Created by Peter Fogg on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SurveyDetailViewController.h"

@interface SurveyDetailViewController ()

@end

@implementation SurveyDetailViewController

@synthesize survey = _survey;
@synthesize surveyLabel = _surveyLabel;
@synthesize answers = _answers;

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
	
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.surveyLabel.text = self.survey.title;
  self.answers = [NSMutableArray arrayWithCapacity:[self.survey.questions count]];
  for(int i = 0; i < [self.survey.questions count]; i++) {
    [self.answers insertObject:[NSNull new] atIndex:i];
  }
}

- (void)viewDidUnload
{
  [self setSurveyLabel:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.survey.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  cell.textLabel.text = [self.survey.questions objectAtIndex:indexPath.row];
  return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if([[segue identifier] isEqualToString:@"answerQuestion"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSString *question = [self.survey.questions objectAtIndex:indexPath.row];
    [[segue destinationViewController] setQuestion:question];
    [[segue destinationViewController] setRow:indexPath.row];
    [[segue destinationViewController] setParent:self];
  }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}

- (IBAction)submit:(id)sender {
  BOOL shouldSubmit = true;
  for(int i = 0; i < [self.answers count]; i++) {
    if([[self.answers objectAtIndex:i] isKindOfClass:[NSNull class]]) {
      shouldSubmit = false;
    }
  }
  if(!shouldSubmit) {
    UIAlertView *problem = [[UIAlertView alloc] initWithTitle:@"Problem!" message:@"Answer all the questions!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [problem show];
  }
  else {
    NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
    [responseDict setObject:self.answers forKey:@"answers"];
    [responseDict setObject:self.survey.title forKey:@"survey"];
    NSData *responseData = [NSJSONSerialization dataWithJSONObject:responseDict options:0 error:nil];
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8000/testapp/response"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:responseData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *err) {
      UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"All went well." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
      [success show];
    }];
  }
}

@end
