//
//  WHMessage.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHMessage.h"
#import "WHHistory.h"
#import "WHAttachment.h"

@implementation WHMessage

@synthesize parent = _parent, originalMessage = _originalMessage, 
            timestamp = _timestamp, author = _author, 
            message = _message, attachment = _attachment;

- (id)initWithString:(NSString *)string
{
    self = [super init];
    if (self)
    {
        self.originalMessage = string;
    }
    
    return self;
}

- (void)process
{
    [WHHistory message:[NSString stringWithFormat:NSLocalizedString(@"Processing \"%@\"", @""), _originalMessage]];
    NSScanner *scanner = [NSScanner scannerWithString:_originalMessage];
    
    NSString *dateString1, *dateString2;
    
    [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&dateString1];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&dateString2];
    
    NSString *author;
    [scanner scanUpToString:@": " intoString:&author];
    self.author = author;
    
    self.message = [scanner string];
}

- (NSDictionary *)serializableRepresentation
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            _timestamp, @"timestamp", 
            _author, @"author", 
            _message, @"message", nil];
}

@end
