//
//  NSString+Clinching.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Clinching.h"

@implementation NSString (Clinching)

- (NSString *)clinchedStringWithLength:(NSUInteger)length
{
    NSMutableString *string = nil;
    if ([self length] < length)
    {
        string = [self copy];
    } else {
        float length_float = [[NSNumber numberWithInteger:length] floatValue];
        float splitter_float = ceil(length_float * 0.25);
        
        string = [[NSMutableString alloc] init];
        NSString *start = [self substringToIndex:[[NSNumber numberWithFloat:splitter_float] integerValue]];
        
        NSRange range = NSMakeRange([[NSNumber numberWithFloat:
                                      [[NSNumber numberWithInteger:[self length]] floatValue]-splitter_float] integerValue], 
                                    [[NSNumber numberWithFloat:splitter_float-1] integerValue]);
        NSString *end   = [self substringWithRange:range];
        [string appendFormat:@"%@...%@", start, end];
    }
    return string;
}

@end
