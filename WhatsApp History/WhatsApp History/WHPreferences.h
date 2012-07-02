//
//  WHPreferences.h
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark Preferences

extern NSString * const WHCurrentTemplatePluginBundleKey;

#pragma mark Notifications

extern NSString * const WHSelectDropEndedNotification;

extern NSString * const WHBeginProcessingNotification;
extern NSString * const WHDiscardProcessingNotification;
extern NSString * const WHEndProcessingNotification;

extern NSString * const WHHistoryErrorNotification;
extern NSString * const WHHistoryProgressNotification;

#pragma mark Errors

extern NSString * const WHErrorDomain;

@interface WHPreferences : NSObject

@end
