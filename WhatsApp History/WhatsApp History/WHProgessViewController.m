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
- (void)progress:(NSNotification *)notification;
@end

@implementation WHProgessViewController

@synthesize maximumProgress, currentProgress, message, history;

- (id)initWithHistory:(WHHistory *)aHistory;
{
    self = [super initWithNibName:@"ProgressView" bundle:[NSBundle mainBundle]];
    if (self)
    {
        self.history = aHistory;
        self.currentProgress = 0;
        self.message = NSLocalizedString(@"Beginning processing", @"");
        
        self.maximumProgress = 2;
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(progress:) 
                                                     name:WHHistoryProgressNotification 
                                                   object:nil];
        
        [history addObserver:self forKeyPath:@"lineCount" options:NSKeyValueObservingOptionNew context:nil];
        [history addObserver:self forKeyPath:@"mediaCount" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [history removeObserver:self forKeyPath:@"lineCount"];
    [history removeObserver:self forKeyPath:@"mediaCount"];
}

- (void)awakeFromNib
{
    [history performSelector:@selector(process) withObject:nil afterDelay:0.1];
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    maximumProgress = history.lineCount + history.mediaCount + 2;
}

- (void)progress:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    if ([[dict valueForKey:@"step"] integerValue] + self.currentProgress < self.maximumProgress)
    {
        self.currentProgress += [[dict valueForKey:@"step"] integerValue];
    }
    
    if ([dict valueForKey:@"message"] != nil)
    {
        self.message = [dict valueForKey:@"message"];        
    }
}


@end
