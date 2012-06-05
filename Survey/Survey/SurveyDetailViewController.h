//
//  SurveyDetailViewController.h
//  Survey
//
//  Created by Peter Fogg on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Survey.h"
#import "QuestionViewController.h"

@interface SurveyDetailViewController : UITableViewController

@property (strong, nonatomic) Survey *survey;
@property (weak, nonatomic) IBOutlet UILabel *surveyLabel;
@property (strong, nonatomic) NSMutableArray *answers;


- (IBAction)submit:(id)sender;

@end
