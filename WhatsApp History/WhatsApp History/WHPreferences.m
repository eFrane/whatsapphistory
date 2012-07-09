//
//  WHPreferences.m
//  WhatsApp History
//
//  Constants and Preferences
//
//  Created by Stefan Graupner on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHPreferences.h"

#pragma mark Preferences

NSString * const WHCurrentHistoryStyleKey = @"WHCurrentHistoryStyle";

#pragma mark Notifications

NSString * const WHSelectDropEndedNotification = @"WHSelectDropEndedNotification";

NSString * const WHBeginProcessingNotification   = @"WHBeginProcessingNotification";
NSString * const WHDiscardProcessingNotification = @"WHDiscardProcessingNotification";
NSString * const WHEndProcessingNotification     = @"WHEndProcessingNotification";

NSString * const WHHistoryErrorNotification    = @"WHHistoryErrorNotification";
NSString * const WHHistoryProgressNotification = @"WHHistoryProgressNotification";

#pragma mark Errors

NSString * const WHErrorDomain = @"com.meanderingsoul.WhatsApp-History.ErrorDomain";

@implementation WHPreferences

+ (void)initialize
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Plain", WHCurrentHistoryStyleKey, nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
}

@end
