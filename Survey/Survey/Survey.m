//
//  Survey.m
//  Survey
//
//  Created by Peter Fogg on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Survey.h"

@implementation Survey

@synthesize questions = _questions;
@synthesize title = _title;

- (id)init {
  return [self initWithArray:[[NSMutableArray alloc] initWithCapacity:10] title:@"Foo!"];
}

- (id)initWithArray:(NSMutableArray *)questions title:(NSString *)title; {
  if(self = [super init]) {
    self.questions = questions;
    self.title = title;
  }
  return self;
}

- (void)addQuestion:(NSString *)question {
  [self.questions addObject:question];
}

- (NSString *)description {
  NSMutableString *desc = [[NSMutableString alloc] initWithFormat:@"title: %@ questions:", self.title];
  for(NSString *question in self.questions) {
    [desc appendFormat:@" %@", question];
  }
  return desc;
}

@end
