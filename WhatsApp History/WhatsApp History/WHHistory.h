//
//  WHHistory.h
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHHistory : NSObject

- (id)initWithSourceURL:(NSURL *)sourceURL;

+ (BOOL)validateHistoryAtURL:(NSURL *)historyURL;

@end
