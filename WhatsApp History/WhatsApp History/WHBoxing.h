//
//  WHBoxing.h
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum WHBoxingAttachmentHandlingMode_enum {
    WHMoveBoxingAttachmentHandlingMode, 
    WHDeleteBoxingAttachmentHandlingMode, 
    WHInPlaceBoxingAttachmentHandlingMode
} WHBoxingAttachmentHandlingMode;

@class WHHistory;

@interface WHBoxing : NSObject

@property (readwrite, retain) WHHistory *history;
@property (readwrite, retain) NSURL   *templateSetURL;

@property (readwrite, assign) WHBoxingAttachmentHandlingMode attachmentHandlingMode;

- (id)initWithTemplateSetAtURL:(NSURL *)templateSetURL history:(WHHistory *)history;

- (BOOL)saveToURL:(NSURL *)saveURL error:(NSError *__autoreleasing *)error;
- (void)applyTemplateSet;

@end
