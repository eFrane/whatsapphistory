//
//  WHPreferencesWindowController.h
//  WhatsApp History
//
//  Created by Stefan Graupner on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WHPreferencesWindowController : NSWindowController

@property (assign) IBOutlet NSSegmentedControl *preferencesSectionSelector;
@property (assign) IBOutlet NSTabView *preferencesSectionsTabView;

@end
