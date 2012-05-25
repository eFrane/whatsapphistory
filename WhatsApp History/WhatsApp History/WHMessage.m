//
//  WHMessage.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHMessage.h"
#import "WHHistory.h"

@implementation WHMessage

@synthesize messageText;

- (id)initWithString:(NSString *)string
{
    self = [super init];
    if (self)
    {
        self.messageText = string;
    }
    
    return self;
}

- (void)process
{
    [WHHistory message:[NSString stringWithFormat:NSLocalizedString(@"Processing \"%@\"", @""), messageText]];
}

- (NSDictionary *)serializableRepresentation
{
    return [NSDictionary dictionaryWithObjectsAndKeys:messageText, @"message", nil];
}

@end
