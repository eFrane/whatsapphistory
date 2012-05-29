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
#import "WHPreviewViewController.h"

#import "WHHistory.h"

@interface WHAppDelegate ()
{
    WHSelectViewController *selectViewController;
    WHProgessViewController *progressViewController;
    WHPreviewViewController *previewViewController;
}

- (void)setView:(NSView *)view;

- (void)beginProcessing:(NSNotification *)notification;
- (void)discardProcessing:(NSNotification *)notification;
- (void)endProcessing:(NSNotification *)notification;

- (void)resetApplicationState;

- (void)displayHistoryErrorFromNotification:(NSNotification *)notification;
- (void)displayedHistoryError:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;

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
                                             selector:@selector(discardProcessing:)
                                                 name:WHDiscardProcessingNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(endProcessing:) 
                                                 name:WHEndProcessingNotification 
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

- (void)discardProcessing:(NSNotification *)notification
{
    [self resetApplicationState];
}

- (void)endProcessing:(NSNotification *)notification
{
    WHHistory *history = [notification object];
    if (history != nil)
    {
        previewViewController = [[WHPreviewViewController alloc] init];
        [self setView:[previewViewController view]];
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"Something went wrong.", @"") 
                                         defaultButton:NSLocalizedString(@"OK", @"") 
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:NSLocalizedString(@"Something went wrong. Please try again or file a bug report at %@",
                                                                                   @""), @"http://github.com/eFrane/whatsapphistory/issues"];
        [alert beginSheetModalForWindow:window 
                          modalDelegate:self
                         didEndSelector:@selector(displayedHistoryError:returnCode:contextInfo:) 
                            contextInfo:NULL];
    }
}

- (void)displayHistoryErrorFromNotification:(NSNotification *)notification
{
    NSError *error = (NSError *)[notification object];
    [[NSAlert alertWithError:error] beginSheetModalForWindow:window 
                                               modalDelegate:self
                                              didEndSelector:@selector(displayedHistoryError:returnCode:contextInfo:) 
                                                 contextInfo:NULL];
}

- (void)displayedHistoryError:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [self resetApplicationState];
}

- (void)resetApplicationState
{
    progressViewController = nil;
    previewViewController  = nil;
    [self setView:[selectViewController view]];    
}

@end
