//
//  WHHistory.h
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHHistory : NSObject

@property (readwrite, retain) NSURL *sourceURL;

@property (readwrite, copy) NSString *historyString;
@property (readwrite, copy) NSMutableArray *messages;
@property (readwrite) NSUInteger lineCount;
@property (readwrite) NSUInteger mediaCount;

- (id)initWithSourceURL:(NSURL *)sourceURL;
- (void)process;

+ (void)progress:(NSUInteger)step withMessage:(NSString *)message;

@end
