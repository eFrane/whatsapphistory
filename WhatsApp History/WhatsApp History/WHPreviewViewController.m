//
//  WHPreviewViewController.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHPreviewViewController.h"
#import "WHPreviewViewSavePanelAccessoryViewController.h"

#import "WHMessage.h"

@interface WHPreviewViewController ()
{
}

- (void)discardAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
@end

@implementation WHPreviewViewController

@synthesize history = _history;

- (id)initWithHistory:(WHHistory *)history;
{
    self = [super initWithNibName:@"PreviewView" bundle:[NSBundle mainBundle]];
    if (self)
    {
        self.history = history;
    }
    return self;
}

- (void)discardButton:(id)sender
{
    NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"Really discard?", @"") 
                                     defaultButton:NSLocalizedString(@"Yes", @"") 
                                   alternateButton:NSLocalizedString(@"No", @"") 
                                       otherButton:nil 
                         informativeTextWithFormat:@""];
    
    [alert beginSheetModalForWindow:[[self view] window] 
                      modalDelegate:self
                     didEndSelector:@selector(discardAlertDidEnd:returnCode:contextInfo:) 
                        contextInfo:nil];
}

- (void)discardAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    if (returnCode == NSAlertFirstButtonReturn)
    {
        // do discard
        [[NSNotificationCenter defaultCenter] postNotificationName:WHDiscardProcessingNotification object:nil];
    } 
}

- (void)saveButton:(id)sender
{
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"webarchive"]];
    
    WHPreviewViewSavePanelAccessoryViewController __block *accessoryViewController;
    accessoryViewController = [[WHPreviewViewSavePanelAccessoryViewController alloc] init];
    [accessoryViewController setAvailableFileTypes:
     [NSArray arrayWithObjects:@"Web Archive", @"Folder", nil]];
    
    [savePanel setAccessoryView:[accessoryViewController view]];
    
    [savePanel beginSheetModalForWindow:[[self view] window] completionHandler:^(NSInteger result) {
        if (result == NSAlertDefaultReturn)
        {
            // TODO: do save
        }
    }];
}


@end
