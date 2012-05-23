//
//  WHHistory.m
//  WhatsApp History
//
//  Errors in WHHistory are posted as WHHistoryErrorNotification with
//  their NSError object set as the notification's object.
//
//  Created by Stefan Graupner on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHHistory.h"

@interface WHHistory ()
- (void)progress:(NSUInteger)step withMessage:(NSString *)message;
@end

@implementation WHHistory

@synthesize sourceURL = _sourceURL;
@synthesize lineCount = _lineCount;
@synthesize mediaCount = _mediaCount;

- (id)initWithSourceURL:(NSURL *)sourceURL
{
    self = [super init];
    if (self)
    {
        self.sourceURL = sourceURL;
    }
    return self;
}

+ (BOOL)validateHistoryAtURL:(NSURL *)historyURL
{    
    // TODO: implement
    
    return YES;
}

- (void)progress:(NSUInteger)step withMessage:(NSString *)message
{
    NSMutableDictionary *progressDict = [[NSMutableDictionary alloc] initWithCapacity:2];
    [progressDict setValue:[NSNumber numberWithInteger:step] forKey:@"step"];
    [progressDict setValue:message forKey:@"message"];
    [[NSNotificationCenter defaultCenter] postNotificationName:WHHistoryProgressNotification object:self userInfo:progressDict];
}

- (void)process
{
    [self progress:0 withMessage:NSLocalizedString(@"Counting Lines...", @"")];
}

@end
