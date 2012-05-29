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

@interface WHPreviewViewController : NSViewController

@property (readwrite, assign) WHHistory *history;

@property (readwrite, assign) IBOutlet WebView *webView;

- (id)initWithHistory:(WHHistory *)history;
- (IBAction)discardButton:(id)sender;
- (IBAction)saveButton:(id)sender;

@end
