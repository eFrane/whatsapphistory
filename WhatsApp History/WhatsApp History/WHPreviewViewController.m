//
//  WHPreviewViewController.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHPreviewViewController.h"
#import "WHPreviewViewSavePanelAccessoryViewController.h"
#import "WHPreviewViewTableCellView.h"

#import "WHMessage.h"

@interface WHPreviewViewController ()
{
    CGFloat defaultRowHeight;
}

- (void)discardAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
@end

@implementation WHPreviewViewController

@synthesize history = _history, tableView = _tableView;

#pragma mark -
#pragma mark General View Controller Stuff

- (id)initWithHistory:(WHHistory *)history;
{
    self = [super initWithNibName:@"PreviewView" bundle:[NSBundle mainBundle]];
    if (self)
    {
        self.history = history;
        defaultRowHeight = 50.0; // may be too small but should be sufficient in many cases
    }
    return self;
}

- (void)awakeFromNib
{    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
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

#pragma mark -
#pragma mark Table View Datasource and Delegate methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [_history.messages count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    WHPreviewViewTableCellView *view = [tableView makeViewWithIdentifier:@"MessageCellView" owner:self];
    
    WHMessage *message = [[_history messages] objectAtIndex:row];
    
    [view.userName setStringValue:message.author];
    [view.timestamp setObjectValue:message.timestamp];
    [view.userImage setImage:message.userImage];
    [[view.messageView textStorage] setAttributedString:message.attributedMessage];
    [view.messageView setDelegate:self];
    
    return view;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    CGFloat (^heightForStringDrawing)(NSAttributedString *, CGFloat) = ^(NSAttributedString *string, CGFloat width)
    {
        NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:string];
        //NSTextContainer *textContainer [NSTextContainer alloc] initWithContainerSize:NSMakeSize(width, FLT_MAX)];
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:NSMakeSize(width, FLT_MAX)];
        NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
        
        [layoutManager addTextContainer:textContainer];
        [textStorage addLayoutManager:layoutManager];
        
        [textContainer setLineFragmentPadding:0.0];
        (void) [layoutManager glyphRangeForTextContainer:textContainer];
        
        return [layoutManager usedRectForTextContainer:textContainer].size.height;
    };
    
    WHMessage *message = [[_history messages] objectAtIndex:row];
    return defaultRowHeight + heightForStringDrawing(message.attributedMessage, tableView.frame.size.width-16);
}

@end
