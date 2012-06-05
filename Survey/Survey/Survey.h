//
//  Survey.h
//  Survey
//
//  Created by Peter Fogg on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Survey : NSObject

@property (nonatomic, copy) NSMutableArray *questions;
@property (nonatomic, copy) NSString *title;

- (id)init;
- (id)initWithArray:(NSMutableArray *)questions title:(NSString *)title;
- (void)addQuestion:(NSString *)question;

@end