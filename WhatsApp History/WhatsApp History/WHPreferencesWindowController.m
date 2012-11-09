//
//  WHPreferencesWindowController.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHPreferencesWindowController.h"

@interface WHPreferencesWindowController ()

@end

@implementation WHPreferencesWindowController

@synthesize preferencesSectionSelector, preferencesSectionsTabView;

- (id)init
{
    self = [super initWithWindowNibName:@"Preferences" owner:self];
    if (self)
    {
        
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
