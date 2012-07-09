//
//  WHExport.h
//  WhatsApp History
//
//  Created by Stefan Graupner on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WHHistory.h"

@interface WHWebsiteExport : NSObject

@property (readwrite, retain) WHHistory *history;
@property (readwrite, retain) NSURL *folderURL;

- initWithHistory:(WHHistory *)history folderURL:(NSURL *)folderURL;
- (void)save;

@end
