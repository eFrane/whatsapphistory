//
//  WHMessage.h
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WHAttachment;

@interface WHMessage : NSObject

@property (readwrite, assign) WHMessage *parent;

@property (readwrite, copy) NSString *originalMessage;

@property (readwrite, retain) NSDate *timestamp;
@property (readwrite, retain) NSString *author;
@property (readwrite, retain) NSString *message;

@property (readwrite, copy) WHAttachment *attachment;

- (id)initWithString:(NSString *)string;
- (void)process;
- (NSDictionary *)serializableRepresentation;

@end
