//
//  WHProgessViewController.h
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WHHistory;

@interface WHProgessViewController : NSViewController

@property (readwrite) NSUInteger maximumProgress;
@property (readwrite) NSUInteger currentProgress;
@property (readwrite, copy) NSString *message;

@property (readwrite, copy) WHHistory *history;

- (id)initWithHistory:(WHHistory *)aHistory;

@end
