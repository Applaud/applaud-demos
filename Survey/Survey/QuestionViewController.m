//
//  QuestionViewController.m
//  Survey
//
//  Created by Peter Fogg on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionViewController.h"

@interface QuestionViewController ()

@end

@implementation QuestionViewController
@synthesize questionLabel = _questionLabel;
@synthesize answerField = _answerField;
@synthesize question = _question;
@synthesize response = _response;
@synthesize parent = _parent;
@synthesize row = _row;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {

  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.questionLabel.text = self.question;
  self.answerField.delegate = self;
}

- (void)viewDidUnload
{
  [self setQuestionLabel:nil];
  [self setAnswerField:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  self.response = textField.text;
  [textField resignFirstResponder];
  return TRUE;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  SurveyDetailViewController *parent = (SurveyDetailViewController *)self.parent;
  if(self.response) {
    [parent.answers removeObjectAtIndex:self.row];
    [parent.answers insertObject:self.response atIndex:self.row];
    UITableViewCell *cell = [parent.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.row inSection:0]];
    cell.detailTextLabel.text = @"Answered";
  }
}
- (IBAction)doneEditing:(UITextField *)sender {
  self.response = sender.text;
  [sender resignFirstResponder];
}
@end
