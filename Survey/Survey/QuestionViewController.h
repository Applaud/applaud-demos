//
//  QuestionViewController.h
//  Survey
//
//  Created by Peter Fogg on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyDetailViewController.h"

@interface QuestionViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITextField *answerField;
@property (copy, nonatomic) NSString *question;
@property (strong, nonatomic) NSString *response;
@property (strong, nonatomic) UITableViewController* parent;
@property NSUInteger row;
- (IBAction)doneEditing:(UITextField *)sender;
@end
