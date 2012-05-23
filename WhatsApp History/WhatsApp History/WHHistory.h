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
@property (readonly) NSUInteger lineCount;
@property (readonly) NSUInteger mediaCount;

- (id)initWithSourceURL:(NSURL *)sourceURL;
- (void)process;

+ (BOOL)validateHistoryAtURL:(NSURL *)historyURL;

@end
