//
//  WHPreviewViewController.h
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#import "WHHistory.h"

@interface WHPreviewViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, NSTextViewDelegate>

@property (readwrite, assign) WHHistory *history;
@property (assign) IBOutlet NSTableView *tableView;

- (id)initWithHistory:(WHHistory *)history;
- (IBAction)discardButton:(id)sender;
- (IBAction)saveButton:(id)sender;

@end
