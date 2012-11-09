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

#import "WHPreferencesWindowController.h"

#import "WHHistory.h"

@interface WHAppDelegate ()
{
    WHSelectViewController *selectViewController;
    WHProgessViewController *progressViewController;
    WHPreviewViewController *previewViewController;
    
    WHPreferencesWindowController *preferencesWindowController;
    
    NSView *currentView;
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

- (id)init
{
    self = [super init];
    if (self)
    {
        selectViewController = [[WHSelectViewController alloc] init];
        [WHPreferences initialize];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
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
    
    [[window contentView] addSubview:[selectViewController view]];
    currentView = [selectViewController view];
    [self setView:[selectViewController view]];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)displayPreferences:(id)sender
{
    if (preferencesWindowController == nil)
    {
        preferencesWindowController = [[WHPreferencesWindowController alloc] init];
    }
    
    [preferencesWindowController.window makeKeyAndOrderFront:self ];
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
    
    [[window contentView] setWantsLayer:YES];
    
    [NSAnimationContext beginGrouping];
    
    [[[window contentView] animator] replaceSubview:currentView with:view];
    [[window animator] setFrame:windowFrame display:YES];
    
    CGFloat originY = [window.contentView frame].size.height;
    originY -= view.frame.size.height;
    
    [[[[window.contentView subviews] objectAtIndex:0] animator] setFrameOrigin:NSMakePoint(0, originY)];
    
    [NSAnimationContext endGrouping];
    
    currentView = (NSView *)view;
    
    if ([[view nextKeyView] isKindOfClass:[NSResponder class]])
    {
        [window makeFirstResponder:[view nextKeyView]];
    }
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
    NSLog(@"called.");
    [self resetApplicationState];
}

- (void)endProcessing:(NSNotification *)notification
{
    WHHistory *history = [notification object];
    if (history != nil)
    {
        previewViewController = [[WHPreviewViewController alloc] initWithHistory:history];
        [self setView:[previewViewController view]];
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"Something went wrong.", @"Generic error message") 
                                         defaultButton:NSLocalizedString(@"OK", @"Generic OK button title") 
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:
                          NSLocalizedString(@"Something went wrong. Please try again or file a bug report at %@",
                                            @"Generic error message description"), 
                          @"http://github.com/eFrane/whatsapphistory/issues"];
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
