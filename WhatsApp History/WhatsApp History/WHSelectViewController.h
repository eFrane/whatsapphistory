//
//  WHSelectViewController.h
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WHSelectViewController : NSViewController

@property (assign) IBOutlet NSBox *dropZone;
@property (readwrite, copy) NSURL *sourceURL;
@property (readwrite, copy) NSString *displayedSourceURL;

@property (assign) IBOutlet NSButton *selectButton;
@property (assign) IBOutlet NSButton *processButton;

- (IBAction)selectSource:(id)sender;
- (IBAction)process:(id)sender;

@end
