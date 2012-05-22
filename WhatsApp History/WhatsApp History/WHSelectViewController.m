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

@end

@implementation WHSelectViewController

@synthesize dropZone, sourceURL, displayedSourceURL;

- (id)init
{
    self = [super initWithNibName:@"SelectView" bundle:[NSBundle mainBundle]];
    if (self)
    {
        [self addObserver:self 
               forKeyPath:@"sourceURL" 
                  options:NSKeyValueObservingOptionNew 
                  context:nil];
        displayedSourceURL = NSLocalizedString(@"Drop File or Folder here", @"");
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"sourceURL"];
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
        } else 
        {
            self.displayedSourceURL = NSLocalizedString(@"Drop File or Folder here", @"");
        }
    }
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

- (void)process:(id)sender
{
    if (sourceURL)
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
