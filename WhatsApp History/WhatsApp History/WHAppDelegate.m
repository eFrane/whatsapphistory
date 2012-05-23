//
//  WHAppDelegate.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHAppDelegate.h"

#import "WHSelectViewController.h"
#import "WHProgessViewController.h"

#import "WHHistory.h"

@interface WHAppDelegate ()
{
    WHSelectViewController *selectViewController;
    WHProgessViewController *progressViewController;
}

- (void)setView:(NSView *)view;

- (void)beginProcessing:(NSNotification *)notification;

- (void)displayHistoryErrorFromNotification:(NSNotification *)notification;

@end

@implementation WHAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    selectViewController = [[WHSelectViewController alloc] init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(beginProcessing:) 
                                                 name:WHBeginProcessingNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(displayHistoryErrorFromNotification:) 
                                                 name:WHHistoryErrorNotification 
                                               object:nil];
    
    [self setView:[selectViewController view]];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setView:(NSView *)view
{
    if (![window makeFirstResponder:window])
    {
        return;
    }
    
    NSSize currentSize = [[window contentView] frame].size;
    NSSize newSize = [view frame].size;
    
    float deltaWidth = newSize.width - currentSize.width;
    float deltaHeight = newSize.height - currentSize.height;
    
    NSRect windowFrame = [window frame];
    windowFrame.size.width += deltaWidth;
    windowFrame.size.height += deltaHeight;
    
    [window setContentView:nil];
    [window setFrame:windowFrame display:YES animate:YES];    
    [window setContentView:view];
    
    [[window contentView] becomeFirstResponder];
}

- (void)beginProcessing:(NSNotification *)notification
{
    WHHistory *history = [[WHHistory alloc] initWithSourceURL:
                          [[notification userInfo] objectForKey:@"sourceURL"]];
    
    progressViewController = [[WHProgessViewController alloc] initWithHistory:history];
    
    [self setView:[progressViewController view]];
}

- (void)displayHistoryErrorFromNotification:(NSNotification *)notification
{
    NSError *error = (NSError *)[notification object];
    [[NSAlert alertWithError:error] runModal];
}

@end
