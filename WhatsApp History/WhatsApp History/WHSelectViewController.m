//
//  WHSelectViewController.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHSelectViewController.h"

#import "WHHistory.h"

@interface WHSelectViewController ()
- (void)changeSourceURL:(NSNotification *)notification;
@end

@implementation WHSelectViewController

@synthesize dropZone, sourceURL, displayedSourceURL, selectButton, processButton;

- (id)init
{
    self = [super initWithNibName:@"SelectView" bundle:[NSBundle mainBundle]];
    if (self)
    {
        [self addObserver:self 
               forKeyPath:@"sourceURL" 
                  options:NSKeyValueObservingOptionNew 
                  context:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(changeSourceURL:) 
                                                     name:WHSelectDropEndedNotification 
                                                   object:nil];
        
        displayedSourceURL = NSLocalizedString(@"Drop File or Folder here", @"");
        
        sourceURL = nil;
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"sourceURL"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"sourceURL"])
    {
        if ([sourceURL class] == [NSURL class])
        {
            self.displayedSourceURL = [NSString stringWithFormat:NSLocalizedString(@"Currently selected: %@", @""), [sourceURL lastPathComponent]];
            [processButton becomeFirstResponder];
        } else 
        {
            self.displayedSourceURL = NSLocalizedString(@"Drop File or Folder here", @"");
        }
    }
}

- (void)awakeFromNib
{
    [selectButton becomeFirstResponder];
}

- (void)selectSource:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setMessage:NSLocalizedString(@"Choose WhatsApp History file or archive", @"")];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObjects:
                                    @"zip", @"tar.gz", @"tar.bz2", @"txt", nil]];
    
    [openPanel beginSheetModalForWindow:[[self view] window] completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton)
        {
            // handle
            if ([WHHistory validateHistoryAtURL:[openPanel URL]])
            {
                self.sourceURL = [openPanel URL];
            }
        }
    }];
}

- (void)changeSourceURL:(NSNotification *)notification
{
    self.sourceURL = [notification object];
}

- (void)process:(id)sender
{
    if (sourceURL != nil)
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:sourceURL, 
                                  @"sourceURL", nil];
        NSNotification *notification = [NSNotification notificationWithName:WHBeginProcessingNotification
                                                                     object:self 
                                                                   userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    } else
    {
        NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"No source given.", @"") 
                                         defaultButton:NSLocalizedString(@"OK", @"")
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:NSLocalizedString(@"You must choose a source before processing.", @"")];
        [alert setAlertStyle:NSWarningAlertStyle];
        
        [alert beginSheetModalForWindow:[[self view] window] 
                          modalDelegate:nil 
                         didEndSelector:NULL
                            contextInfo:NULL];
    }
}

@end
