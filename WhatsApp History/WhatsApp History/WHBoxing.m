//
//  WHBoxing.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHBoxing.h"

#import "WHHistory.h"

@implementation WHBoxing

@synthesize templateSetURL = _templateSetURL, history = _history;

@synthesize attachmentHandlingMode;

- (id)initWithTemplateSetAtURL:(NSURL *)templateSetURL 
                      history:(WHHistory *)history
{
    self = [super init];
    if (self)
    {
        self.templateSetURL = templateSetURL;
        self.history = history;
        
        attachmentHandlingMode = WHInPlaceBoxingAttachmentHandlingMode;
    }
    return self;
}

- (BOOL)saveToURL:(NSURL *)saveURL error:(NSError *__autoreleasing *)error
{
    return NO;
}

- (void)applyTemplateSet
{
    
}

@end
