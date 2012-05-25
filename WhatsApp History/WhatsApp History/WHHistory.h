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

@property (readwrite, retain) NSOperationQueue *operations;

- (id)initWithSourceURL:(NSURL *)sourceURL;
- (void)process;

+ (void)message:(NSString *)message;

@end
