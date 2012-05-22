//
//  WHSelectViewBox.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHSelectViewBox.h"

@interface WHSelectViewBox ()

@end

@implementation WHSelectViewBox

- (void)awakeFromNib
{
    [self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
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
    NSArray *files = [pBoard propertyListForType:NSFilenamesPboardType];
    [files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // TODO: finish dragging implementation
    }];
    return YES;
}

@end
