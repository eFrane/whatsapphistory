//
//  NSDate+JSONFormat.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDate+JSONFormat.h"

@implementation NSDate (JSONFormat)

- (NSString *)JSONFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    return [formatter stringFromDate:self];
}

@end
