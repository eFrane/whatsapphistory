//
//  WHProgessViewController.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHProgessViewController.h"
#import "WHHistory.h"

@interface WHProgessViewController ()

@end

@implementation WHProgessViewController

@synthesize maximumProgress, currentProgress, message, history;

- (id)initWithHistory:(WHHistory *)aHistory;
{
    self = [super initWithNibName:@"ProgressView" bundle:[NSBundle mainBundle]];
    if (self)
    {
        self.message = NSLocalizedString(@"Beginning processing", @"");
        self.maximumProgress = 1;
        self.currentProgress = 0;
        
        self.history = aHistory;
    }
    return self;
}

@end
