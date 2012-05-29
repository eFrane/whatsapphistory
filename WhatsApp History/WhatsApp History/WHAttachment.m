//
//  WHAttachment.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHAttachment.h"

@implementation WHAttachment

@synthesize type = _type, data = _data, filename = _filename;

- initWithAttachmentType:(WHAttachmentType)type 
                    data:(NSData *)data 
        originalFilename:(NSString *)originalFilename
{
    self = [super init];
    if (self)
    {
        self.type     = type;
        self.data     = data;
        self.filename = originalFilename;
    }
    return self;
}

- (BOOL)saveDataRelativeToBaseURL:(NSURL *)baseURL error:(NSError *__autoreleasing *)error
{
    NSURL *saveURL = [NSURL URLWithString:_filename relativeToURL:baseURL];
    return [_data writeToURL:saveURL options:NSDataWritingAtomic error:error];
}

@end
