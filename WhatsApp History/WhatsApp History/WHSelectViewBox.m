//
//  WHSelectViewBox.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHSelectViewBox.h"
#import "WHHistory.h"

@interface WHSelectViewBox ()

@end

@implementation WHSelectViewBox

- (void)awakeFromNib
{
    [self registerForDraggedTypes:
     [NSArray arrayWithObjects:NSURLPboardType, nil]];
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSDragOperation sourceDragMask = [sender draggingSourceOperationMask];
    if (sourceDragMask & NSDragOperationLink) return NSDragOperationLink;
    if (sourceDragMask & NSDragOperationCopy) return NSDragOperationCopy;
    return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pBoard = [sender draggingPasteboard];
    
    if ([[pBoard types] containsObject:NSURLPboardType])
    {
        NSURL *url = [NSURL URLFromPasteboard:pBoard];
        if ([WHHistory validateHistoryAtURL:url]) 
        {
            NSNotification *notification = [NSNotification 
                                            notificationWithName:WHSelectDropEndedNotification 
                                            object:url];
            [[NSNotificationCenter defaultCenter] postNotification:notification];            
            
            return YES;
        }
    }

    return NO;
}

@end
