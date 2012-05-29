//
//  WHAttachment.h
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum WHAttachmentType_enum {
    WHImageAttachmentType, 
    WHAudioAttachmentType, 
    WHVideoAttachmentType, 
    WHVCardAttachmentType
} WHAttachmentType;

@interface WHAttachment : NSObject

@property (readwrite, assign) WHAttachmentType type;
@property (readwrite, assign) NSData *data;
@property (readwrite, assign) NSString *filename;

- initWithAttachmentType:(WHAttachmentType)type 
                    data:(NSData *)data 
        originalFilename:(NSString *)originalFilename;

- (BOOL)saveDataRelativeToBaseURL:(NSURL *)baseURL error:(NSError **)error;

@end
