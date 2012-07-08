//
//  WHProgessViewController.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHProgessViewController.h"
#import "WHHistory.h"

#import "NSString+Clinching.h"

@interface WHProgessViewController ()
- (void)progress:(NSNotification *)notification;
@end

@implementation WHProgessViewController

@synthesize progressIndicator, message, history;

- (id)initWithHistory:(WHHistory *)aHistory;
{
    self = [super initWithNibName:@"ProgressView" bundle:[NSBundle mainBundle]];
    if (self)
    {
        self.history = aHistory;
        self.message = NSLocalizedString(@"Processing", @"");
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(progress:) 
                                                     name:WHHistoryProgressNotification 
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [progressIndicator startAnimation:self];
    [history performSelector:@selector(process) withObject:nil afterDelay:0.4];
}

- (void)progress:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    
    if ([dict valueForKey:@"message"] != nil)
    {
        NSString *msg = [dict valueForKey:@"message"];
        self.message = [msg clinchedStringWithLength:140];
    }
}

- (void)cancel:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WHHistoryErrorNotification object:nil];
}

@end
