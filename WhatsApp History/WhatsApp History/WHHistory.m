//
//  WHHistory.m
//  WhatsApp History
//
//  Errors in WHHistory are posted as WHHistoryErrorNotification with
//  their NSError object set as the notification's object.
//
//  Created by Stefan Graupner on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHHistory.h"

@implementation WHHistory

- (id)initWithSourceURL:(NSURL *)sourceURL
{
    self = [super init];
    
    return self;
}

+ (BOOL)validateHistoryAtURL:(NSURL *)historyURL
{    
    return YES;
}

@end
