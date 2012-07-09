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

#import "WHWebsiteExport.h"

#import <Quartz/Quartz.h>

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
    NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"Really discard?", @"Processing discard evaluation question") 
                                     defaultButton:NSLocalizedString(@"Yes", @"Generic yes button title") 
                                   alternateButton:NSLocalizedString(@"No", @"Generic no button title") 
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
    [savePanel setDirectoryURL:[[NSURL fileURLWithPath:NSHomeDirectory()] URLByAppendingPathComponent:@"Desktop"]];
    [savePanel setShowsHiddenFiles:NO];
    [savePanel setExtensionHidden:YES];
    
    WHPreviewViewSavePanelAccessoryViewController __block *accessoryViewController;
    accessoryViewController = [[WHPreviewViewSavePanelAccessoryViewController alloc] init];
    [accessoryViewController setAvailableFileTypes:[NSArray arrayWithObjects:
                                                    NSLocalizedString(@"PDF (Portable Document Format", @"PDF file format description"), 
                                                    NSLocalizedString(@"EPS (Encapsulated Postscript", @"EPS file format description"), 
                                                    NSLocalizedString(@"Website export", @"Website export. *drumroll*"), 
                                                    nil]];
    
    [savePanel setAccessoryView:[accessoryViewController view]];
    [savePanel beginSheetModalForWindow:[[self view] window] completionHandler:^(NSInteger result) {
        if (result != NSOKButton) return;
        
        if ([accessoryViewController.fileType.stringValue 
             isEqualToString:NSLocalizedString(@"PDF (Portable Document Format", @"PDF file format description")])
        {
            NSString *fileName = [savePanel.URL relativePath];
            
            if (![fileName.pathExtension isEqualToString:@"pdf"])
                fileName = [[savePanel.URL URLByAppendingPathExtension:@"pdf"] relativePath];
            
            NSPrintInfo *printInfo;
            NSPrintInfo *sharedInfo;
            NSPrintOperation *printOperation;
            NSMutableDictionary *printInfoDict;
            NSMutableDictionary *sharedDict;
            
            sharedInfo = [NSPrintInfo sharedPrintInfo];
            sharedDict = [sharedInfo dictionary];
            
            printInfoDict = [NSMutableDictionary dictionaryWithDictionary:sharedDict];
            [printInfoDict setObject:fileName forKey:NSPrintSavePath];
            
            printInfo = [[NSPrintInfo alloc] initWithDictionary:printInfoDict];
            [printInfo setHorizontalPagination:NSFitPagination];
            [printInfo setVerticalPagination:NSAutoPagination];
            
            [printInfo setJobDisposition:NSPrintSaveJob];
            
            printOperation = [NSPrintOperation printOperationWithView:_tableView printInfo:printInfo];
            [printOperation setShowsPrintPanel:NO];
            [printOperation setShowsProgressPanel:YES];
            
            // run the print operation with a short delay to end the modal state
            [printOperation performSelector:@selector(runOperation) withObject:nil afterDelay:0.3];
        }
        
        if ([accessoryViewController.fileType.stringValue 
             isEqualToString:NSLocalizedString(@"EPS (Encapsulated Postscript", @"EPS file format description")])
        {
            NSData *data = [_tableView dataWithEPSInsideRect:_tableView.bounds];
            [data writeToURL:[[savePanel URL] URLByAppendingPathExtension:@"eps"] atomically:NO];
        }
        
        if ([accessoryViewController.fileType.stringValue 
             isEqualToString:NSLocalizedString(@"Website export", @"Website export. *drumroll*")])
        {
            WHWebsiteExport *export = [[WHWebsiteExport alloc] initWithHistory:self.history folderURL:savePanel.URL];
            [export save];
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
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:NSMakeSize(width, FLT_MAX)];
        NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
        
        [layoutManager addTextContainer:textContainer];
        [textStorage addLayoutManager:layoutManager];
        
        [textContainer setLineFragmentPadding:0.0];
        (void) [layoutManager glyphRangeForTextContainer:textContainer];
        
        return [layoutManager usedRectForTextContainer:textContainer].size.height;
    };
    
    WHMessage *message = [[_history messages] objectAtIndex:row];
    return defaultRowHeight + heightForStringDrawing(message.attributedMessage, 697);
}

@end
